const objectRepository = {
  "default": {
    "label_username_or_email": (page) => page.getByLabel("Username or Email"),
    "label_password": (page) => page.getByLabel("Password"),
    "button_sign_in": (page) => page.getByRole("button", { name: "Sign in" }),
    "null_user_management": (page) => page.getByRole("menubar").getByText("User Management"),
    "placeholder_quick_search": (page) => page.getByPlaceholder("Quick Search.."),
    "text_sierra_leo": (page) => page.getByText("Sierra, Leo"),
    "fastackbutton": (page) => page.locator(".fa-stack > button"),
    "button_user_details": (page) => page.getByRole("button", { name: "User Details" }),
    "div": (page) => page.locator("div").filter({ hasText: {} }),
    "locator_673179": (page) => page.locator("div:nth-child(4) > .fii-c-tile > .fii-c-notification > .fa-stack"),
    "locator_43180": (page) => page.locator("div:nth-child(5) > .fii-c-tile > .fii-c-notification > .fa-stack"),
    "locator_579217": (page) => page.locator("div:nth-child(9) > .fii-c-tile > .fii-c-notification > .fa-stack > button"),
    "label_profile_menu": (page) => page.getByLabel("Profile Menu"),
    "button_sign_out": (page) => page.getByRole("button", { name: "Sign Out" }),
  },
};
module.exports = objectRepository;