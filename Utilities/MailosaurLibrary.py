import os
from mailosaur import MailosaurClient
from mailosaur.models import SearchCriteria
from robot.api.deco import keyword

class MailosaurLibrary:
    """Robot Framework library wrapping Mailosaur Python client."""

    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self, api_key='default_api_key'):
        api_key = api_key or os.getenv("MAILOSAUR_API_KEY")
        if not api_key:
            raise ValueError(
                "Mailosaur API key must be provided either via argument "
                "or MAILOSAUR_API_KEY environment variable."
            )
        self.client = MailosaurClient(api_key)

    # ---------- Adresy e-mail ----------
    @keyword(name="Generate Email Address")
    def generate_email_address(self, server_id):
        """Zwraca losowy adres e-mail dla podanego server_id.

        Wykorzystuje mailosaur.servers.generate_email_address(server_id),
        np. 'bgwqj@SERVER_ID.mailosaur.net'.
        """
        return self.client.servers.generate_email_address(server_id)

    # ---------- Odbieranie wiadomości ----------
    @keyword(name="Wait For Message With Subject")
    def wait_for_message_with_subject(
        self,
        server_id,
        subject,
        timeout_ms=120000,
        sent_to=None,
    ):
        """Czeka na maila o danym tytule (i opcjonalnie wysłanego na konkretny adres)."""
        criteria = SearchCriteria()
        criteria.subject = subject
        if sent_to:
            criteria.sent_to = sent_to

        message = self.client.messages.get(
            server_id,
            criteria,
            timeout=timeout_ms
        )
        return message

    # ---------- Kasowanie wiadomości ----------
    @keyword(name="Delete Message")
    def delete_message(self, message_or_id):
        """Usuwa pojedynczą wiadomość (obiekt Message lub string z id)."""
        message_id = getattr(message_or_id, "id", message_or_id)
        self.client.messages.delete(message_id)

    @keyword(name="Delete All Messages")
    def delete_all_messages(self, server_id):
        """Czyści cały inbox (server). Operacja nieodwracalna."""
        self.client.messages.delete_all(server_id)

    # ---------- Proste helpery do asercji ----------
    @keyword(name="Get Text Body")
    def get_text_body(self, message):
        """Zwraca plaintext body wiadomości (lub pusty string)."""
        if message.text:
            return message.text.body
        return ""
    @keyword(name="Get HTML Body")
    def get_html_body(self, message):
        """Zwraca HTML body wiadomości (lub pusty string)."""
        if message.html:
            return message.html.body
        return ""
    
    @keyword(name="Get Subject")
    def get_subject(self, message):
        """Zwraca temat wiadomości."""
        return message.subject
    
    @keyword(name="Email Body Should Contain")
    def email_body_should_contain(self, message, expected_text):
        """Sprawdza, że treść maila zawiera podany fragment."""
        body = None

        # 1) Preferuj tekst jeśli jest
        if getattr(message, "text", None) and getattr(message.text, "body", None):
            body = message.text.body
        # 2) W przeciwnym razie użyj HTML
        elif getattr(message, "html", None) and getattr(message.html, "body", None):
            body = message.html.body
        else:
            raise AssertionError("Email nie ma ani text.body, ani html.body – nie ma czego sprawdzić.")

        if expected_text not in body:
            raise AssertionError(
                f"Nie znaleziono oczekiwanej treści w mailu.\n"
                f"Szukane: '{expected_text}'\n\n"
                f"Body:\n{body}"
            )
