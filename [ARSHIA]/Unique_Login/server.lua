local COLORS = {
    DARK   = "#020c1b",
    MID    = "#0a192f",
    LIGHT  = "#112240",
    AQUA   = "#00f5d4",
    WHITE  = "#e6f1ff",
    GRAY   = "#8892b0",
    GREEN  = "#64ffda",
    RED    = "#ff6b6b",
    YELLOW = "#ffd93d"
}
local smscodedict = {}
function ShowMainMenu(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "stretch",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "Unique RolePlay",
                                        weight = "bolder",
                                        size = "extraLarge",
                                        color = "Accent",
                                        horizontalAlignment = "center",
                                        fontType = "monospace"
                                    },
                                    {
                                        type = "TextBlock",
                                        -- text = "به دنیای واقعی خوش آمدید",
                                        size = "small",
                                        color = COLORS.Light,
                                        horizontalAlignment = "center",
                                        isSubtle = true,
                                        spacing = "small"
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "25px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },


                    {
                        type = "TextBlock",
                        text = "🔐 برای ورود به سرور احراز هویت کنید",
                        horizontalAlignment = "center",
                        color = COLORS.Light,
                        weight = "bolder",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "📅 " .. os.date("%Y/%m/%d") .. "  ⏰ " .. os.date("%H:%M"),
                        horizontalAlignment = "center",
                        color = COLORS.Light,
                        isSubtle = true,
                        spacing = "small"
                    }
                },
                cornerRadius = "0 0 15px 15px",
                padding = "25px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🔑  ورود با حساب کاربری",
                data = { action = "login" }
            },
            {
                type = "Action.Submit",
                title = "📝  ثبت‌نام حساب جدید",
                style = "positive",
                data = { action = "register" }
            },
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "login" then
            ShowLoginForm(deferrals)
        elseif data.action == "register" then
            ShowRegisterStep1_Phone(deferrals)
        else
            ShowMainMenu(deferrals)
        end
    end)
end

function ShowLoginForm(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔑",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "ورود به حساب",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "نام کاربری و رمز عبور خود را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 نام کاربری یا شماره تلفن (بدون 0)",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "username",
                        placeholder = "نام کاربری خود را وارد کنید...",
                        isRequired = false
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "password",
                        placeholder = "رمز عبور...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        -- text = "💡 رمز خود را فراموش کرده‌اید؟",
                        color = "Attention",
                        isSubtle = true,
                        horizontalAlignment = "right",
                        wrap = true
                    }
                },
                cornerRadius = "0 0 0 0",
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🚀  ورود به سرور",
                style = "positive",
                data = { action = "do_login" }
            },
            {
                type = "Action.Submit",
                title = "❓ فراموشی رمز عبور",
                data = { action = "forgot_password" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowMainMenu(deferrals)
        elseif data.action == "forgot_password" then
            ShowForgotPassword_Step1(deferrals)
        elseif data.action == "do_login" then
            local username = data.username or ""
            local password = data.password or ""

            if username == "" or password == "" then
                ShowError(deferrals, "لطفاً نام کاربری و رمز عبور را وارد کنید!", function()
                    ShowLoginForm(deferrals)
                end)
                return
            end

            CheckLogin(username, password, deferrals, function(isValid,license)
                if isValid then
                    ShowSuccess(deferrals, "ورود موفق! خوش آمدید " .. username, function()
                        deferrals.identifier = license
                        formPassed(deferrals)
                    end)
                else
                    ShowError(deferrals, "نام کاربری یا رمز عبور اشتباه است!", function()
                        ShowLoginForm(deferrals)
                    end)
                end
            end)
        else
            ShowLoginForm(deferrals)
        end
    end)
end

function ShowRegisterStep1_Phone(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "📝",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "ثبت‌نام جدید",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۱ از ۳: شماره تلفن",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "📱 شماره تلفن همراه خود را وارد کنید",
                        color = COLORS.Light,
                        spacing = "medium",
                        wrap = true
                    },
                    {
                        type = "TextBlock",
                        text = "کد تأیید به این شماره ارسال خواهد شد",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "شماره تلفن (بدون 0 اول):",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "phone",
                        placeholder = "9123456789",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        text = "مثال: 9123456789 (بدون +98)",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 شماره شما نزد ما محفوظ می‌ماند",
                        color = "Good",
                        size = "small",
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "📨  ارسال کد تأیید",
                style = "positive",
                data = { action = "send_code" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowMainMenu(deferrals)
        elseif data.action == "send_code" then
            local phone = data.phone or ""

            if phone == "" then
                ShowError(deferrals, "لطفاً شماره تلفن را وارد کنید!", function()
                    ShowRegisterStep1_Phone(deferrals)
                end)
                return
            end

            if #phone < 10 or #phone > 10 then
                ShowError(deferrals, "شماره تلفن باید ۱۰ رقم باشد!", function()
                    ShowRegisterStep1_Phone(deferrals)
                end)
                return
            end

            CheckPhoneExists(phone, function(phoneExists)
                if phoneExists then
                    ShowError(deferrals, "این شماره تلفن قبلاً ثبت شده است!", function()
                        ShowLoginForm(deferrals)
                    end)
                    return
                end

                local code = SendSMSCode(phone)
                if code then
                    ShowRegisterStep2_VerifyCode(deferrals, phone, code)
                else
                    ShowError(deferrals, "خطا در ارسال پیامک! لطفاً دوباره تلاش کنید.", function()
                        ShowRegisterStep1_Phone(deferrals)
                    end)
                end
            end)
        else
            ShowRegisterStep1_Phone(deferrals)
        end
    end)
end

function ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "📨",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "تأیید شماره تلفن",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۲ از ۳: کد تأیید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },
            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "کد ۶ رقمی ارسال شده را وارد کنید",
                        color = COLORS.Light,
                        wrap = true,
                        spacing = "medium"
                    },
                    {
                        type = "TextBlock",
                        text = "📱 شماره: 98" .. phone,
                        color = "Accent",
                        weight = "bolder",
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "کد تأیید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "code",
                        placeholder = "______",
                        isRequired = false,
                        maxLength = 6
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "⏰ کد تا ۲ دقیقه معتبر است",
                        color = "Warning",
                        size = "small",
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "✅  تأیید کد",
                style = "positive",
                data = { action = "verify_code" }
            },
            -- {
            --     type = "Action.Submit",
            --     title = "🔄  ارسال مجدد کد",
            --     data = { action = "resend_code" }
            -- },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowRegisterStep1_Phone(deferrals)
        elseif data.action == "resend_code" then
            local newCode = SendSMSCode(phone)
            if newCode then
                ShowRegisterStep2_VerifyCode(deferrals, phone, newCode)
            else
                ShowError(deferrals, "خطا در ارسال مجدد کد!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
            end
        elseif data.action == "verify_code" then
            local enteredCode = data.code or ""

            if enteredCode == "" then
                ShowError(deferrals, "لطفاً کد تأیید را وارد کنید!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
                return
            end

            if enteredCode ~= sentCode then
                ShowError(deferrals, "کد تأیید اشتباه است!", function()
                    ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
                end)
                return
            end
            smscodedict[phone] = nil
            ShowRegisterStep3_UserPass(deferrals, phone)
        else
            ShowRegisterStep2_VerifyCode(deferrals, phone, sentCode)
        end
    end)
end

function ShowRegisterStep3_UserPass(deferrals, phone)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔐",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "اطلاعات حساب",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "مرحله ۳ از ۳: نام کاربری و رمز عبور",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },
            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 نام کاربری *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "username",
                        placeholder = "حداقل ۳ کاراکتر...",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        -- text = "📛 این نام در سرور نمایش داده می‌شود",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "password",
                        placeholder = "حداقل ۶ کاراکتر...",
                        isRequired = false,
                        style = "password"
                    },
                    {
                        type = "TextBlock",
                        text = "🔒 تکرار رمز عبور *",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "confirm_password",
                        placeholder = "رمز را مجدداً وارد کنید...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "✅ با ثبت‌نام، قوانین سرور را می‌پذیرم",
                        color = COLORS.Light,
                        isSubtle = true,
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "🚀  ثبت‌نام و ورود",
                style = "positive",
                data = { action = "do_register" }
            },
            -- {
            --     type = "Action.Submit",
            --     title = "↩️  بازگشت",
            --     data = { action = "back" }
            -- }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowRegisterStep2_VerifyCode(deferrals, phone, "123456")
        elseif data.action == "do_register" then
            local username = data.username or ""
            local password = data.password or ""
            local confirm = data.confirm_password or ""

            if username == "" or password == "" or confirm == "" then
                ShowError(deferrals, "لطفاً تمام فیلدها را پر کنید!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if #username < 3 then
                ShowError(deferrals, "نام کاربری باید حداقل ۳ کاراکتر باشد!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if #password < 6 then
                ShowError(deferrals, "رمز عبور باید حداقل ۶ کاراکتر باشد!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            if password ~= confirm then
                ShowError(deferrals, "رمز عبور و تکرار آن یکسان نیست!", function()
                    ShowRegisterStep3_UserPass(deferrals, phone)
                end)
                return
            end

            CheckUsernameExists(username, function(usernameExists)
                if usernameExists then
                    ShowError(deferrals, "این نام کاربری قبلاً انتخاب شده است!", function()
                        ShowRegisterStep3_UserPass(deferrals, phone)
                    end)
                    return
                end

                RegisterUser(username, password, phone, deferrals, function(success,license)
                    if success then
                        ShowSuccess(deferrals, "ثبت‌نام موفق! خوش آمدید " .. username, function()
                            deferrals.identifier = license
                            formPassed(deferrals)
                        end)
                    else
                        ShowError(deferrals, "خطا در ثبت‌نام! لطفاً دوباره تلاش کنید.", function()
                            ShowRegisterStep3_UserPass(deferrals, phone)
                        end)
                    end
                end)
            end)
        else
            ShowRegisterStep3_UserPass(deferrals, phone)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--         مرحله: فراموشی رمز عبور - شماره تلفن
-- ─────────────────────────────────────────────────────────
function ShowForgotPassword_Step1(deferrals)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            -- هدر
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔑",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "فراموشی رمز عبور",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "شماره تلفن ثبت‌شده خود را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "📱 شماره تلفن ثبت‌شده:",
                        color = COLORS.Light,
                        wrap = true,
                        spacing = "medium"
                    },
                    {
                        type = "Input.Text",
                        id = "phone",
                        placeholder = "9123456789",
                        isRequired = false
                    },
                    {
                        type = "TextBlock",
                        text = "کد بازیابی به این شماره ارسال خواهد شد",
                        color = COLORS.Light,
                        size = "small",
                        isSubtle = true,
                        spacing = "small"
                    },

                    -- خط جداکننده
                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "💡 اگر شماره ثبت‌شده ندارید، با پشتیبانی تماس بگیرید",
                        color = COLORS.Light,
                        size = "small",
                        wrap = true,
                        isSubtle = true
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "📨  ارسال کد بازیابی",
                style = "positive",
                data = { action = "send_reset_code" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت به ورود",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowLoginForm(deferrals)
        elseif data.action == "send_reset_code" then
            local phone = data.phone or ""

            if phone == "" or #phone < 10 then
                ShowError(deferrals, "لطفاً شماره تلفن معتبر وارد کنید!", function()
                    ShowForgotPassword_Step1(deferrals)
                end)
                return
            end

            GetUserByPhone(phone, function(userData)
                if not userData then
                    ShowError(deferrals, "این شماره تلفن در سیستم ثبت نشده است!", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                    return
                end

                local resetCode = SendSMSCode(phone)
                if resetCode then
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, userData.username)
                else
                    ShowError(deferrals, "خطا در ارسال کد! دوباره تلاش کنید.", function()
                        ShowForgotPassword_Step1(deferrals)
                    end)
                end
            end)
        else
            ShowForgotPassword_Step1(deferrals)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--         مرحله: فراموشی رمز عبور - تأیید کد
-- ─────────────────────────────────────────────────────────
function ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            -- هدر
            {
                type = "Container",
                backgroundColor = COLORS.MID,
                items = {
                    {
                        type = "ColumnSet",
                        columns = {
                            {
                                type = "Column",
                                width = "auto",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "🔐",
                                        size = "extraLarge"
                                    }
                                }
                            },
                            {
                                type = "Column",
                                width = "stretch",
                                verticalContentAlignment = "center",
                                items = {
                                    {
                                        type = "TextBlock",
                                        text = "تأیید کد بازیابی",
                                        weight = "bolder",
                                        size = "large",
                                        color = "Accent"
                                    },
                                    {
                                        type = "TextBlock",
                                        text = "کد ارسال‌شده را وارد کنید",
                                        size = "small",
                                        color = COLORS.Light,
                                        isSubtle = true
                                    }
                                }
                            }
                        }
                    }
                },
                cornerRadius = "15px 15px 0 0",
                padding = "20px"
            },

            -- اطلاعات کاربر
            {
                type = "Container",
                backgroundColor = COLORS.LIGHT,
                items = {
                    {
                        type = "TextBlock",
                        text = "👤 حساب: " .. username,
                        color = "Accent",
                        weight = "bolder"
                    },
                    {
                        type = "TextBlock",
                        text = "📱 شماره: 98" .. phone,
                        color = COLORS.Light,
                        size = "small"
                    }
                },
                padding = "15px",
                cornerRadius = "10px",
                spacing = "medium"
            },

            {
                type = "Container",
                backgroundColor = COLORS.DARK,
                items = {
                    {
                        type = "TextBlock",
                        text = "کد تأیید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "code",
                        placeholder = "کد ۶ رقمی...",
                        isRequired = false,
                        maxLength = 6
                    },

                    {
                        type = "TextBlock",
                        text = " ",
                        size = "small"
                    },

                    {
                        type = "TextBlock",
                        text = "🔒 رمز عبور جدید:",
                        weight = "bolder",
                        color = COLORS.Light,
                        size = "small",
                        spacing = "small"
                    },
                    {
                        type = "Input.Text",
                        id = "new_password",
                        placeholder = "حداقل ۶ کاراکتر...",
                        isRequired = false,
                        style = "password"
                    },
                    {
                        type = "Input.Text",
                        id = "confirm_password",
                        placeholder = "تکرار رمز جدید...",
                        isRequired = false,
                        style = "password"
                    },

                    {
                        type = "TextBlock",
                        text = "━━━━━━━━━━━━━━━━━━━━━━━",
                        horizontalAlignment = "center",
                        color = "Accent",
                        spacing = "medium"
                    },

                    {
                        type = "TextBlock",
                        text = "⏰ کد تا ۲ دقیقه معتبر است",
                        color = "Warning",
                        size = "small",
                        spacing = "small"
                    }
                },
                padding = "20px"
            }
        },

        actions = {
            {
                type = "Action.Submit",
                title = "✅  تغییر رمز عبور",
                style = "positive",
                data = { action = "reset_password" }
            },
            {
                type = "Action.Submit",
                title = "↩️  بازگشت",
                data = { action = "back" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if data.action == "back" then
            ShowLoginForm(deferrals)
        elseif data.action == "reset_password" then
            local code = data.code or ""
            local newPassword = data.new_password or ""
            local confirm = data.confirm_password or ""

            if code == "" then
                ShowError(deferrals, "لطفاً کد تأیید را وارد کنید!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            if code ~= resetCode then
                ShowError(deferrals, "کد تأیید اشتباه است!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            if #newPassword < 6 then
                ShowError(deferrals, "رمز عبور باید حداقل ۶ کاراکتر باشد!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            if newPassword ~= confirm then
                ShowError(deferrals, "رمز عبور و تکرار آن یکسان نیست!", function()
                    ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                end)
                return
            end

            UpdatePassword(phone, newPassword, function(success)
                if success then
                    ShowSuccess(deferrals, "رمز عبور با موفقیت تغییر کرد!", function()
                        ShowLoginForm(deferrals)
                    end)
                else
                    ShowError(deferrals, "خطا در تغییر رمز! دوباره تلاش کنید.", function()
                        ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
                    end)
                end
            end)
        else
            ShowForgotPassword_Step2(deferrals, phone, resetCode, username)
        end
    end)
end

-- ─────────────────────────────────────────────────────────
--              صفحات پیام (Error / Success)
-- ─────────────────────────────────────────────────────────
function ShowError(deferrals, message, callback)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = "#1a0a0a",
                items = {
                    {
                        type = "TextBlock",
                        text = "❌",
                        size = "extraLarge",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = "خطا!",
                        weight = "bolder",
                        size = "large",
                        color = "Attention",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = message,
                        color = COLORS.Light,
                        horizontalAlignment = "center",
                        wrap = true,
                        spacing = "medium"
                    }
                },
                padding = "30px",
                cornerRadius = "15px",
                borderColor = "Attention",
                borderThickness = "2px"
            }
        },
        actions = {
            {
                type = "Action.Submit",
                title = "🔄  تلاش مجدد",
                data = { action = "retry" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if callback then
            callback()
        else
            ShowMainMenu(deferrals)
        end
    end)
end

function ShowSuccess(deferrals, message, callback)
    local card = {
        type = "AdaptiveCard",
        version = "1.5",
        minHeight = "200px",
        body = {
            {
                type = "Container",
                backgroundColor = "#0a1a0a",
                items = {
                    {
                        type = "TextBlock",
                        text = "✅",
                        size = "extraLarge",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = "موفق!",
                        weight = "bolder",
                        size = "large",
                        color = "Good",
                        horizontalAlignment = "center"
                    },
                    {
                        type = "TextBlock",
                        text = message,
                        color = COLORS.Light,
                        horizontalAlignment = "center",
                        wrap = true,
                        spacing = "medium"
                    }
                },
                padding = "30px",
                cornerRadius = "15px",
                borderColor = "Good",
                borderThickness = "2px"
            }
        },
        actions = {
            {
                type = "Action.Submit",
                title = "➡️  ادامه",
                style = "positive",
                data = { action = "continue" }
            }
        }
    }

    deferrals.presentCard(json.encode(card), function(data)
        if callback then
            callback()
        else
            formPassed(deferrals)
        end
    end)
end

-- OTP ;D

local function SMSHolderTimer(phone)
    Citizen.SetTimeout(1*60*60*1000, function()
        smscodedict[phone] = nil
    end)
end

function SendSMSCode(phone)
    if not smscodedict[phone] then
        local code = tostring(math.random(100000, 999999))
        smscodedict[phone] = code
        SMSHolderTimer(phone)
        print(phone .. " : " .. code)
        local payload = {
            mobile = tostring(phone),
            templateId = Config.SMS.TemplateId,
            parameters = {
                {
                    name = "OTP",
                    value = code
                }
            }
        }
        PerformHttpRequest(Config.SMS.ApiUrl, function(err, text, headers)
            if err == 200 or err == 0 then
                local data = json.decode(text)
                if data then
                    print("--------------------")
                    print("📥 ریسپانس API:")
                    print(json.encode(data, { indent = true }))
                    print("--------------------")
                else
                    print("📄 ریسپانس خام:", text)
                end
            else
                print("❌ ارور HTTP:", err)
            end
        end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json', ['X-API-KEY'] = Config.SMS.ApiKey })
        return code
    end 
    return smscodedict[phone]
end




-- DataBase

local function generateRandomString(length)
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    
    for i = 1, length do
        local randomIndex = math.random(1, #charset)
        result[i] = charset:sub(randomIndex, randomIndex)
    end
    
    return table.concat(result)
end

-- تولید لایسنس یکتا با فرمت مشخص
local function generateUniqueLicense(prefix)
    local prefix = prefix or "steam:"
    local attempts = 0
    local maxAttempts = 100
    
    repeat
        attempts = attempts + 1
        
        -- فرمت: LIC-XXXX-XXXX-XXXX (چهار بخش 4 کاراکتری)
        local part1 = generateRandomString(4)
        local part2 = generateRandomString(4)
        local part3 = generateRandomString(4)
        local license = string.format("%s-%s-%s-%s", prefix, part1, part2, part3)
        
        -- بررسی تکراری نبودن در دیتابیس
        local result = MySQL.query.await(
            "SELECT COUNT(*) as count FROM `login_users` WHERE license = @license",
            { ['@license'] = license }
        )
        
        if result and result[1] and result[1].count == 0 then
            return license
        end
        
    until attempts >= maxAttempts
    
    -- اگر بعد از 100 بار نتونست لایسنس یکتا بسازه
    -- یه لایسنس با timestamp بساز (fallback)
    return string.format("%s-%s-%s-%s", 
        prefix, 
        generateRandomString(4), 
        os.time(), 
        generateRandomString(4)
    )
end



-- function CheckLicenseLink(def, cb)

--     local license
--     for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
--         if string.sub(v, 1, string.len("license:")) == "license:" then
--             license = v
--         end
--     end

--     local query = "SELECT * FROM login_users WHERE license = @license"
--     MySQL.Async.fetchAll(query, {
--         ["@license"] = license
--     }, function(result)
--         cb(result and #result > 0)
--     end)
-- end

-- SECURITY FIX: was comparing/storing passwords in PLAINTEXT before.
-- Hashing happens inside the SQL itself (SHA2-256) so no plaintext
-- password is ever written to the database or a query log.
function CheckLogin(username, password, def, cb)
    local query = "SELECT * FROM login_users WHERE (username = @username OR phone = @username) AND password = SHA2(@password, 256)"
    MySQL.Async.fetchAll(query, {
        ["@username"] = username,
        ["@password"] = password
    }, function(result)
        if result and #result > 0 then
            cb(true, result[1].license)
        else
            cb(false, nil)
        end
    end)
    -- updateLicense(username, def)
end

function CheckPhoneExists(phone, cb)
    local query = "SELECT id FROM login_users WHERE phone = @phone LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@phone"] = phone
    }, function(result)
        cb(result and #result > 0)
    end)
end

function CheckUsernameExists(username, cb)
    local query = "SELECT id FROM login_users WHERE username = @username LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@username"] = username
    }, function(result)
        cb(result and #result > 0)
    end)
end

function GetUserByPhone(phone, cb)
    local query = "SELECT id, username, phone, license FROM login_users WHERE phone = @phone LIMIT 1"
    MySQL.Async.fetchAll(query, {
        ["@phone"] = phone
    }, function(result)
        if result and #result > 0 then
            cb({
                id       = result[1].id,
                username = result[1].username,
                phone    = result[1].phone,
                license  = result[1].license
            })
        else
            cb(nil)
        end
    end)
end

function RegisterUser(username, password, phone, def, cb)

    -- local license ,steam = nil, nil
    -- for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
    --     if string.sub(v, 1, string.len("license:")) == "license:" then
    --         license = v
    --     end
    -- end
    -- steam = "steam".. string.sub(license, string.len("license:"), string.len(license))

    local license = generateUniqueLicense()
    -- SECURITY FIX: SHA2-256 the password inside the query, same as CheckLogin
    local query = [[
        INSERT INTO login_users (username, password, phone, license)
        VALUES (@username, SHA2(@password, 256), @phone, @license)
    ]]
    MySQL.Async.execute(query, {
        ["@username"] = username,
        ["@password"] = password,
        ["@phone"]    = phone,
        ["@license"]  = license

    }, function(insertId)
        cb(insertId ~= nil and insertId > 0,license)
    end)
end

function UpdatePassword(phone, newPassword, cb)
    local query = "UPDATE login_users SET password = SHA2(@password, 256) WHERE phone = @phone"
    MySQL.Async.execute(query, {
        ["@password"] = newPassword,
        ["@phone"]    = phone
    }, function(affected)
        cb(affected and affected > 0)
    end)
end

function updateLicense(userName, def)
    local license
    for _, v in ipairs(GetPlayerIdentifiers(def.src)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        end
    end

    local query = "UPDATE login_users SET license = @license WHERE username = @username"
    MySQL.Async.execute(query, {["@license"] = license, ["@username"] = userName })
end

local inLoginFormPlayers = {}
local playersidentifieronconnect = {}

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)

    local src = source
    local steam = nil
    deferrals.src = src
    deferrals.defer()
    Wait(100)
    deferrals.update("در حال بررسی اطلاعات...")
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
            break
        end
    end

    if steam then
        deferrals.identifier = steam
        formPassed(deferrals)
    else
        ShowMainMenu(deferrals)
    end
end)

local playersidentifieronjoin = {}

AddEventHandler('playerJoining', function()
    local src = source
    local ip = nil
    for _, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            break
        end
    end
    local found = false
    local temp = playersidentifieronjoin
    for id, ident in pairs(temp) do
        if playersidentifieronconnect[ip] == ident then
            DropPlayer(tonumber(id),"Fardi Ba Accounte Shoma Varede Server Shod Passworde Khod Ra Reset Konid !!")
            found = true
        end
    end
    if found then
        Wait(1000)
        DropPlayer(src,"Fardi Ba Accounte Shoma Dar Server Ast Passworde Khod Ra Reset Konid !!")
    else
        playersidentifieronjoin[tostring(src)] = playersidentifieronconnect[ip]
    end
end)

AddEventHandler('playerDropped', function()
	local src = source
	Wait(3000)
	playersidentifieronjoin[tostring(src)] = nil
end)

function formPassed(deferrals)
    local ip = nil
    for _, v in ipairs(GetPlayerIdentifiers(deferrals.src)) do
        if string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = v
            break
        end
    end
    playersidentifieronconnect[ip] = deferrals.identifier
    inLoginFormPlayers[deferrals.src] = nil
    deferrals.update("در حال ورود با اکانت ...")
    Wait(1000)
    -- BUG FIX: deferrals.done() was commented out here, meaning every
    -- player who successfully logged in would be stuck forever on
    -- "در حال ورود با اکانت..." and never actually get let into the
    -- server (nothing else in this resource ever called deferrals.done()
    -- for them). TriggerEvent is kept in case another resource of yours
    -- hooks 'playerConnecting2', but the connection itself no longer
    -- depends on that resource existing.
    TriggerEvent('playerConnecting2', deferrals)
    deferrals.done()
end

exports("isInLoginMenu", function(src)
    -- return inLoginFormPlayers[src] == true
    return true
end)

exports("getidentifier", function(src)
    -- return inLoginFormPlayers[src] == true
    return playersidentifieronjoin[tostring(src)]
end)