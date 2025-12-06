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

    # ---------- Email Addresses ----------
    @keyword(name="Generate Email Address")
    def generate_email_address(self, server_id):
        """Returns a random email address for the given server_id.

        Uses mailosaur.servers.generate_email_address(server_id),
        e.g. 'bgwqj@SERVER_ID.mailosaur.net'.
        """
        return self.client.servers.generate_email_address(server_id)

    # ---------- Receiving Messages ----------
    @keyword(name="Wait For Message With Subject")
    def wait_for_message_with_subject(
        self,
        server_id,
        subject,
        timeout_ms=120000,
        sent_to=None,
    ):
        """Waits for an email with the given subject (optionally sent to a specific address)."""
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

    # ---------- Deleting Messages ----------
    @keyword(name="Delete Message")
    def delete_message(self, message_or_id):
        """Deletes a single message (Message object or string with id)."""
        message_id = getattr(message_or_id, "id", message_or_id)
        self.client.messages.delete(message_id)

    @keyword(name="Delete All Messages")
    def delete_all_messages(self, server_id):
        """Clears the entire inbox (server). Irreversible operation."""
        self.client.messages.delete_all(server_id)

    # ---------- Assertions helpers ----------
    @keyword(name="Get Text Body")
    def get_text_body(self, message):
        """Returns the plaintext body of the message (or an empty string)."""
        if message.text:
            return message.text.body
        return ""
    @keyword(name="Get HTML Body")
    def get_html_body(self, message):
        """Returns the HTML body of the message (or an empty string)."""
        if message.html:
            return message.html.body
        return ""
    
    @keyword(name="Get Subject")
    def get_subject(self, message):
        """Returns the subject of the message."""
        return message.subject
    
    @keyword(name="Email Body Should Contain")
    def email_body_should_contain(self, message, expected_text):
        """Checks that the email body contains the given text fragment."""
        body = None

        # 1) Prefer text if available
        if getattr(message, "text", None) and getattr(message.text, "body", None):
            body = message.text.body
        # 2) Otherwise use HTML
        elif getattr(message, "html", None) and getattr(message.html, "body", None):
            body = message.html.body
        else:
            raise AssertionError("Email has neither text.body nor html.body – nothing to check.")

        if expected_text not in body:
            raise AssertionError(
                f"Text not found in email body.\n"
                f"Searched for: '{expected_text}'\n\n"
                f"Body:\n{body}"
            )
