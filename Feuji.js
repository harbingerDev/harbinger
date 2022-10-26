import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {

  // Go to about:blank
  await page.goto('about:blank');

});