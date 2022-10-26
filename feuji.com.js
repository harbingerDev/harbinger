import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {

  // Go to https://www.feuji.com/
  await page.goto('https://www.feuji.com/');

});