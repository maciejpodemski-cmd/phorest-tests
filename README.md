# Phorest – UI Tests for Sending Gift Voucher

This project contains **Robot Framework** UI tests for the flow of purchasing and sending a gift voucher.

## Project Structure

```text
Pages/
  purchase.resource
  success.resource
  summaryAndCheckout.resource

Tests/
  sendingGiftVoucher.robot

Utilities/
  Common.resource
  EmailWorkflow.resource
  MailosaurLibrary.py
  SetupAndTeardown.resource
  vars.resource

requirements.txt
results/        # directory for test reports (created/overwritten when tests run)

Prerequisites

To run the tests locally you need:

Python 3.11+

pip (Python package manager)

Google Chrome installed

ChromeDriver compatible with your installed Chrome version

Example on macOS: brew install chromedriver

On Windows/Linux, download the matching ChromeDriver and ensure it is on your PATH

Additionally, if you use Mailosaur in your tests:

A Mailosaur account

API key and server ID configured in the project (see Configuration section)

Installation

Clone the repository:
git clone <your_repository_url>
cd phorest-tests

Create and activate a virtual environment:
python -m venv .venv

# macOS / Linux:
source .venv/bin/activate

# Windows (PowerShell / CMD):
.venv\Scripts\activate

Install dependencies:
python -m pip install --upgrade pip
pip install -r requirements.txt

Configuration
1. Test Variables
The file:
Utilities/vars.resource
contains configuration variables used by the tests, such as:

application base URL
environment settings
Mailosaur server ID 

Before running the tests, make sure that the values in vars.resource match your target test environment.

Running Tests Locally
1. Run the main UI scenarios

To run the main gift voucher test suite:
robot -d results Tests/sendingGiftVoucher.robot

-d results tells Robot Framework to store all test output in the results directory.

Tests/sendingGiftVoucher.robot is the UI test suite.

2. Run all tests in the Tests directory
robot -d results Tests

Running Tests in GitHub Actions (Optional)

This repository can be integrated with GitHub Actions using a workflow such as:
.github/workflows/runPhorestTests.yaml
That workflow can be triggered manually from the Actions tab and runs the same test suite as locally.
Locally, you can run the equivalent scenario with:
