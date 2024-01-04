import { test, expect, request } from "@playwright/test";
const objectRepository = require("../objectRepository")
const dataRepository = require("../dataRepository.json")
require("dotenv").config()

test("ui_demo @smoke", async ({ page, context }) => {
  await page.goto("https://ebs-v80-qa-portal.fischeridentitydev.com/tes/portal/dashboard/");
  await page.goto("https://ebs-v80-qa-portal.fischeridentitydev.com/tes/portal/authentication/login");
  await page.goto("https://ebs-v80-qa-20-sso.fischeridentitydev.com/auth/realms/qa-tes/protocol/openid-connect/auth?client_id=identity-portal&redirect_uri=https%3A%2F%2Febs-v80-qa-portal.fischeridentitydev.com%2Ftes%2Fportal%2Fauthentication%2Flogin-callback&response_type=code&scope=openid%20profile&state=dcead0755b97459383b3a4040aeafb0e&code_challenge=KZrnhKMlHY0BORhcupS__MJ8a0xbyhxUqOfZApN-Xl8&code_challenge_method=S256&response_mode=query&acr_values=urn%3Afischer%3Aloa%3A1fa%3Apwd");
  await objectRepository.default.label_username_or_email(page).click();
  await objectRepository.default.label_username_or_email(page).fill(dataRepository[process.env.EXECUTION_ENVIRONMENT].data_713720);
  await objectRepository.default.label_password(page).click();
  await objectRepository.default.label_password(page).fill(dataRepository[process.env.EXECUTION_ENVIRONMENT].data_800819);
  await objectRepository.default.button_sign_in(page).click();
  await page.goto("https://ebs-v80-qa-portal.fischeridentitydev.com/tes/portal/dashboard/");
  await objectRepository.default.null_user_management(page).click();
  await objectRepository.default.placeholder_quick_search(page).press("CapsLock");
  await objectRepository.default.placeholder_quick_search(page).fill(dataRepository[process.env.EXECUTION_ENVIRONMENT].data_725188);
  await objectRepository.default.text_sierra_leo(page).click();
  await objectRepository.default.fastackbutton(page).first().click();
  await objectRepository.default.button_user_details(page).click();
  await page
    .locator("div")
    .filter({ hasText: /^Manage Profile$/ })
    .locator("span")
    .click();
  await objectRepository.default.button_user_details(page).click();
  await page
    .locator("div")
    .filter({ hasText: /^Login History$/ })
    .locator("span")
    .click();
  await objectRepository.default.button_user_details(page).click();
  await objectRepository.default.locator_673179(page).click();
  await objectRepository.default.button_user_details(page).click();
  await objectRepository.default.locator_43180(page).click();
  await objectRepository.default.button_user_details(page).click();
  await objectRepository.default.locator_579217(page).click();
  await objectRepository.default.button_user_details(page).click();
  await objectRepository.default.label_profile_menu(page).click();
  await objectRepository.default.button_sign_out(page).click();
});
