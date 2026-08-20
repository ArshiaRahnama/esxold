

config = {}
config.Levels = {
[1]=30,[2]=40,[3]=50,[4]=60,[5]=70,[6]=80,[7]=90,[8]=100,[9]=110,[10]=120,
[11]=130,[12]=140,[13]=150,[14]=160,[15]=170,[16]=180,[17]=190,[18]=200,[19]=210,[20]=220,
[21]=230,[22]=240,[23]=250,[24]=260,[25]=270,[26]=280,[27]=290,[28]=300,[29]=310,[30]=320,
[31]=330,[32]=340,[33]=350,[34]=360,[35]=370,[36]=380,[37]=390,[38]=400,[39]=410,[40]=420,
[41]=430,[42]=440,[43]=450,[44]=460,[45]=470,[46]=480,[47]=490,[48]=500,[49]=510,[50]=520,
[51]=530,[52]=540,[53]=550,[54]=560,[55]=570,[56]=580,[57]=590,[58]=600,[59]=610,[60]=620,
[61]=630,[62]=640,[63]=650,[64]=660,[65]=670,[66]=680,[67]=690,[68]=700,[69]=710,[70]=720,
[71]=730,[72]=740,[73]=750,[74]=760,[75]=770,[76]=780,[77]=790,[78]=800,[79]=810,[80]=820,
[81]=830,[82]=840,[83]=850,[84]=860,[85]=870,[86]=880,[87]=890,[88]=900,[89]=910,[90]=920,
[91]=930,[92]=940,[93]=950,[94]=960,[95]=970,[96]=980,[97]=990,[98]=1000,[99]=1100,[100]=1200,
}

config.AdminXPPermission = 10

Config = {}

Config.QuestsPerDay = 6

Config.CoinAdminPermission = 8
Config.CoinMaxValue        = 1000000
Config.CoinItem            = false

Config.JobQuests = {

    ["police"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-police:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    ["sheriff"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-sheriff:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    ["metropolitan"] = {
        {name = "Onduty", description = "Daryaft Salary Onduty", trigger = "quest-metropolitan:onduty", requiredTrigger = 6, XP = 10, coin = 0.04},
    },

    ["ambulance"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",      trigger = "quest-ambulance:onduty",   requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Revive Player",  description = "Revive 5 Player",            trigger = "quest-ambulance:revive",   requiredTrigger = 5, XP = 20, coin = 0.10},
        {name = "Accept Request", description = "Accept 5 Emergency Request", trigger = "quest-ambulance:acceptreq",requiredTrigger = 5, XP = 15, coin = 0.08},
    },

    ["mechanic"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty",   trigger = "quest-mechanic:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Repair Request", trigger = "quest-mechanic:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},
    },

    ["taxi"] = {
        {name = "Onduty",         description = "Daryaft Salary Onduty", trigger = "quest-taxi:onduty",    requiredTrigger = 6, XP = 10, coin = 0.04},
        {name = "Accept Request", description = "Accept 5 Taxi Request", trigger = "quest-taxi:acceptreq", requiredTrigger = 5, XP = 15, coin = 0.08},




    },
}

Config.DefaultQuest = {




    {name = "Farme Ephedra",     description = "50 Ta Ephedra Bardasht Kon", trigger = "quest-drug:ephedra",     requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Ephedrine",  description = "100 Ta Ephedrine Besaz",     trigger = "quest-drug:ephedrine",   requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Shishe",     description = "20 Ta Shishe Besaz",         trigger = "quest-drug:meth",        requiredTrigger = 20,  XP = 10, coin = 0.04},
    {name = "Foroshe Shishe",    description = "10 Ta Shishe Befrosh",       trigger = "quest-drug:sellmeth",    requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Farme Shahdane",    description = "100 Ta Shahdane Bardasht Kon",trigger = "quest-drug:cannabis",   requiredTrigger = 100, XP = 10, coin = 0.04},
    {name = "Sakhte Marijuana",  description = "500 Ta Marijuana Besaz",     trigger = "quest-drug:marijuana",   requiredTrigger = 100, XP = 10, coin = 0.04},
    {name = "Forosh Marijuana",  description = "250 Ta Marijuana Beforsh",   trigger = "quest-drug:sellmarjuana",requiredTrigger = 250, XP = 10, coin = 0.04},
    {name = "Farme Tokme Cocaine",description = "50 Ta Coca Bardasht Kon",   trigger = "quest-drug:coca",        requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Cocaine",    description = "20 Ta Cocaine Besaz",        trigger = "quest-drug:cocaine",     requiredTrigger = 20,  XP = 10, coin = 0.04},
    {name = "Foroshe Cocaine",   description = "10 Ta Cocaine Befrosh",      trigger = "quest-drug:sellcocaine", requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Sakhte Crack",      description = "10 Ta Crack Besaz",          trigger = "quest-drug:crack",       requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Foroshe Crack",     description = "10 Ta Crack Befrosh",        trigger = "quest-drug:sellcrack",   requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Farme Khash Khaash",description = "50 Ta Khashkhash Bardasht Kon",trigger = "quest-drug:poppy",     requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Sakhte Teryak",     description = "25 Ta Teryak Besaz",         trigger = "quest-drug:opium",       requiredTrigger = 25,  XP = 10, coin = 0.04},
    {name = "Sakhte Heroine",    description = "10 Ta Heroine Besaz",        trigger = "quest-drug:heroine",     requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Foroshe Heroine",   description = "10 Ta Heroine Befrosh",      trigger = "quest-drug:sellheroine", requiredTrigger = 10,  XP = 10, coin = 0.04},
    {name = "Bardashte Gharch",  description = "50 Ta Gharch Bardasht Kon",  trigger = "quest-drug:mushroom",    requiredTrigger = 50,  XP = 10, coin = 0.04},
    {name = "Foroshe Gharchh",   description = "10 Ta Gharch Befrosh",       trigger = "quest-drug:sellmushroom",requiredTrigger = 10,  XP = 10, coin = 0.04},






    {name = "Farme Sang Ma'dan",  description = "20 Bar Sang Dakhele Kamion Bezar", trigger = "quest-jobcenter:stonemine", requiredTrigger = 20, XP = 10, coin = 0.04},
    {name = "Foroshe Sang",       description = "10 Bar Sang Befrosh",              trigger = "quest-jobcenter:sellstone", requiredTrigger = 10, XP = 10, coin = 0.04},
    {name = "Gharbale Sang",      description = "10 Bar Sang Ro Bekesh",            trigger = "quest-jobcenter:washstone", requiredTrigger = 10, XP = 10, coin = 0.04},
    {name = "Zob Ahan",           description = "5 Ta Ahan Zob Kon",                trigger = "quest-jobcenter:zobahan",   requiredTrigger = 5,  XP = 15, coin = 0.06},
    {name = "Zob Tala",           description = "5 Ta Tala Zob Kon",                trigger = "quest-jobcenter:zobtala",   requiredTrigger = 5,  XP = 15, coin = 0.06},






}

Config.GangQuest = {


}

Config.SkillTargetMinutes = 3000
Config.TrackedJobs = {
    police       = "Police",
    sheriff      = "Sheriff",
    metropolitan = "Metropolitan",
    ambulance    = "Ambulance",
    mechanic     = "Mechanic",
    taxi         = "Taxi",
}

Config.SkillMilestones = {
    { percent = 25,  coin = 0.10 },
    { percent = 50,  coin = 0.20 },
    { percent = 75,  coin = 0.35 },
    { percent = 100, coin = 0.75 },
}
