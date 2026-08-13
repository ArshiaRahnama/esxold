Config = {}
Config.RepeatTimeout = 500
Config.CallRepeats = 120
Config.OpenPhone = 288

-- Configs
Config.Language = 'en' -- You have more translations in html.
Config.webhooksscreenshot = "https:// arshiahub.ir/changemesasdds/1324462146993520752/-m1nDasTidW9-WDKDCJGQ-dy_D5mEwyb65zE3Xk4wVVyrqKm_YmtSvqjC_NIAbWYGep6"
Config.Tokovoip = false -- If it is true it will use Tokovoip, if it is false it will use Mumblevoip.
Config.Job = '' -- If you want, you can choose another job and it is the job that will appear in the 'Police' application, modify the html to make it another job.
Config.UseESXLicense = true
Config.UseESXBilling = true

Config.Languages = {
    ['en'] = {
        ["NO_VEHICLE"] = "Hich vasile naghliyei dar atrof nist!",
        ["NO_ONE"] = "Hich kasi dar atrof nist!",
        ["ALLFIELDS"] = "Hame field-ha bayad por shavand!",

        ["RACE_TITLE"] = "Mosabeghe",

        ["WHATSAPP_TITLE"] = "Whatsapp",
        ["WHATSAPP_NEW_MESSAGE"] = "Payame jadid az",
        ["WHATSAPP_MESSAGE_TOYOU"] = "Payame jadid darid",
        ["WHATSAPP_LOCATION_SET"] = "Moghiyat tanzim shod!",
        ["WHATSAPP_SHARED_LOCATION"] = "Moghiyat be eshterak gozashte shod",
        ["WHATSAPP_BLANK_MSG"] = "Nemitooni payam khali ersal koni!",

        ["MAIL_TITLE"] = "Email",
        ["MAIL_NEW"] = "Shoma ye email jadid daryaft kardid az: ",

        ["ADVERTISEMENT_TITLE"] = "Safahat Zard",
        ["ADVERTISEMENT_NEW"] = "Ye agahi jadid dar safahat zard montasher shod!",
        ["ADVERTISEMENT_EMPY"] = "Bayad ye payam vared konid!",

        ["TWITTER_TITLE"] = "Twitter",
        ["TWITTER_NEW"] = "Tweet jadid",
        ["TWITTER_POSTED"] = "Tweet ersal shod!",
        ["TWITTER_GETMENTIONED"] = "Shoma dar ye tweet mention shodid!",
        ["MENTION_YOURSELF"] = "Nemitooni khodet ro mention koni!",
        ["TWITTER_ENTER_MSG"] = "Bayad ye payam vared koni!",

        ["PHONE_DONT_HAVE"] = "Shoma goshi nadarid!",
        ["PHONE_TITLE"] = "Rahnama",
        ["PHONE_CALL_END"] = "Tamas payan yaft",
        ["PHONE_NOINCOMING"] = "Hich tamas voroodi nadarid!",
        ["PHONE_STARTED_ANON"] = "Ye tamas nashenas aghaz kardid!",
        ["PHONE_BUSY"] = "Shoma dar hal hazer mashghool hastid!",
        ["PHONE_PERSON_TALKING"] = "In shakhs dar hal sohbat hast!",
        ["PHONE_PERSON_UNAVAILABLE"] = "In shakhs dar dastres nist!",
        ["PHONE_YOUR_NUMBER"] = "Nemitooni be khodet zang bezani!",
        ["PHONE_MSG_YOURSELF"] = "Nemitooni be khodet payam bedi!",

        ["CONTACTS_REMOVED"] = "In mokhatab hazf shod!",
        ["CONTACTS_NEWSUGGESTED"] = "Ye mokhatab pishnahadi jadid dari!",
        ["CONTACTS_EDIT_TITLE"] = "Virayesh Mokhatab",
        ["CONTACTS_ADD_TITLE"] = "Rahnam",

        ["BANK_TITLE"] = "Bank",
        ["BANK_DONT_ENOUGH"] = "Shoma pool kafi nadarid!",
        ["BANK_NOIBAN"] = "Hich IBAN baraye in shakhs sabt nashode ast!",

        ["CRYPTO_TITLE"] = "Crypto",

        ["GPS_SET"] = "Moghiyat GPS tanzim shod: ",

        ["NUI_SYSTEM"] = "System",
        ["NUI_NOT_AVAILABLE"] = "Dar dastres nist!",
        ["NUI_MYPHONE"] = "Shomare telefon",
        ["NUI_INFO"] = "Ettela'at",

        ["SETTINGS_TITLE"] = "Tanzimat",
        ["PROFILE_SET"] = "Aks profile tanzim shod!",
        ["POFILE_DEFAULT"] = "Aks profile be halat pishfarz bazneshani shod!",
        ["BACKGROUND_SET"] = "Paszamine tanzim shod!",

        ["MEOS_TITLE"] = "MEOS",
        ["MEOS_CLEARED"] = "Hame notification-ha hazf shodand!",
        ["MEOS_GPS"] = "In payam moghiyat GPS nadarad!",
        ["MEOS_NORESULT"] = "Natijei yaft nashod!"


	},
	
}

Config.PhoneApplications = {
    ["phone"] = {
        app = "phone",
        color = "#04b543",
        icon = "fa fa-phone-alt",
        tooltipText = "Phone",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 1,
        Alerts = 0,
    },
    ["whatsapp"] = {
        app = "whatsapp",
        color = "#25d366",
        icon = "fab fa-whatsapp",
        tooltipText = "Whatsapp",
        tooltipPos = "top",
        style = "font-size: 2.8vh";
        job = false,
        blockedjobs = {},
        slot = 2,
        Alerts = 0,
    },
    ["bank"] = {
        app = "bank",
        color = "#9c88ff",
        icon = "fas fa-university",
        tooltipText = "Bank",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 3,
        Alerts = 0,
    },
    ["settings"] = {
        app = "settings",
        color = "#636e72",
        icon = "fa fa-cog",
        tooltipText = "Settings",
        tooltipPos = "top",
        style = "padding-right: .08vh; font-size: 2.3vh";
        job = false,
        blockedjobs = {},
        slot = 4,
        Alerts = 0,
    },
    ["garage"] = {
        app = "garage",
        color = "#575fcf",
        icon = "fas fa-warehouse",
        tooltipText = "Vehicles",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 5,
        Alerts = 0,
    },
    ["polices"] = {
        app = "polices",
        color = "#00FF95",
        icon = "fas fa-building",
        tooltipText = "Services",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 6,
        Alerts = 0,
    },

    ["gallery"] = {
        app = "gallery",
        color = "#AC1D2C",
        icon = "fas fa-images",
        tooltipText = "Gallery",

        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 7,
        Alerts = 0,
    },
    ["camera"] = {
        app = "camera",
        color = "#AC1D2C",
        icon = "fas fa-camera",
        tooltipText = "Camera",
        tooltipPos = "top",
        job = false,
        blockedjobs = {},
        slot = 8,
        Alerts = 0,
    },
    -- ["twitter"] = {
    --     app = "twitter",
    --     color = "#1da1f2",
    --     icon = "fab fa-twitter",
    --     tooltipText = "Twitter",
    --     tooltipPos = "top",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 13,
    --     Alerts = 0,
    -- },
    -- ["mail"] = {
    --     app = "mail",
    --     color = "#ff002f",
    --     icon = "fas fa-envelope",
    --     tooltipText = "Mail",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 8,
    --     Alerts = 0,
    -- },
    -- ["advert"] = {
    --     app = "advert",
    --     color = "#ff8f1a",
    --     icon = "fas fa-ad",
    --     tooltipText = "Adverts",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 7,
    --     Alerts = 0,
    -- },
    -- ["racing"] = {
    --     app = "racing",
    --     color = "#353b48",
    --     icon = "fas fa-flag-checkered",
    --     tooltipText = "Racing",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 9,
    --     Alerts = 0,
    -- },
    -- ["spotify"] = {
    --     app = "spotify",
    --     color = "#82c91e",
    --     icon = "fab fa-spotify",
    --     tooltipText = "Spotify",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 12,
    --     Alerts = 0,
    -- }, 
    -- ["snake"] = {
    --     app = "snake",
    --     color = "#609",
    --     icon = "fas fa-ghost",
    --     tooltipText = "Snake Game",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 11,
    --     Alerts = 0,
    -- },
    -- ["solitary"] = {
    --     app = "solitary",
    --     color = "#e6bb12",
    --     icon = "fas fa-crown",
    --     tooltipText = "Solitary",
    --     job = false,
    --     blockedjobs = {},
    --     slot = 10,
    --     Alerts = 0,
    -- },

}