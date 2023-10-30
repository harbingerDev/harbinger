function getRequiredConfigAndWriteToFile(req) {
  let baseConfig = `const { devices } = require("@playwright/test");
  const RPconfig = {
    enabled: false,
    includeTestSteps: true,
    token: "c7c26122-2def-42b0-a6af-baf17cd1b204",
    endpoint: "http://10.10.90.150:8080/api/v1",
    project: "Trinet",
    launch: "Trinet - Demo execution",
    restClientConfig: {
      timeout: 120000,
      maxContentLength: Infinity,
      maxBodyLength: Infinity,
    },
    attributes: [
      {
        key: "environment",
        value: "qa",
      },
    ],
    description: "Automation execution for Trinet",
  };
const config = {
  testDir: "./tests",
  timeout: defaultTimeout,
  expect: {
    timeout: 5000,
  },
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ["junit", { outputFile: "test-results/results.xml" }],
    ["html"],

    ["@reportportal/agent-js-playwright", RPconfig],
  ],
  use: {
    screenshot: "only-on-failure",
    actionTimeout: 0,
    trace: "on",
    launchOptions:{
      slowMo: 1000
    },
  },
  projects: [
    chromeConfiguration
    firefoxConfiguration
    safariConfiguration
  ],
};

module.exports = config;
`;

  const chromeConfig = `{
    name: "chromium",
    use: {
      ...devices["Desktop Chrome"],
    },
  },`;
  const firefoxConfig = `{
    name: "firefox",
    use: {
      ...devices["Desktop Firefox"],
    },
  },`;
  const safariConfig = ` {
    name: "webkit",
    use: {
      ...devices["Desktop Safari"],
    },
  },`;
  let afterChromeUpdate = req.browsers
    .map((v) => v.toLowerCase())
    .includes("chrome")
    ? baseConfig.replace(/chromeConfiguration/gm, chromeConfig)
    : baseConfig.replace(/chromeConfiguration/gm, "");
  let afterfirefoxUpdate = req.browsers
    .map((v) => v.toLowerCase())
    .includes("firefox")
    ? afterChromeUpdate.replace(/firefoxConfiguration/gm, firefoxConfig)
    : afterChromeUpdate.replace(/firefoxConfiguration/gm, "");
  let afterSafariUpdate = req.browsers
    .map((v) => v.toLowerCase())
    .includes("safari")
    ? afterfirefoxUpdate.replace(/safariConfiguration/gm, safariConfig)
    : afterfirefoxUpdate.replace(/safariConfiguration/gm, "");

  let afterTimeoutUpdate = afterSafariUpdate.replace(
    /defaultTimeout/gm,
    req.default_timeout
  );
  return afterTimeoutUpdate.replace(/[\r\n]+/g, "");
}

module.exports = { getRequiredConfigAndWriteToFile };
