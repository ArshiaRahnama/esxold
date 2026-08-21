config = {}
-- Synced against the real `jobs` table in database.sql (essentialmode base).
-- Server has no 'justice' or 'detective' jobs -- those were leftover
-- placeholders and have been swapped for the actual law-enforcement /
-- intelligence jobs that exist on this server: police, sheriff, fbi,
-- mt (Metropolitan), cia, cid, doa, marshal (each with an off-duty pair).
blackListJob = {
    ['police'] = true,
    ['sheriff'] = true,
    ['offpolice'] = true,
    ['offsheriff'] = true,
    ['mt'] = true,
    ['offmt'] = true,
    ['fbi'] = true,
    ['offfbi'] = true,
    ['cia'] = true,
    ['offcia'] = true,
    ['cid'] = true,
    ['offcid'] = true,
    ['doa'] = true,
    ['offdoa'] = true,
    ['marshal'] = true,
    ['offmarshal'] = true,
}

militaryJobs = {
    ['police'] = true,
    ['sheriff'] = true,
    ['offpolice'] = true,
    ['offsheriff'] = true,
    ['mt'] = true,
    ['offmt'] = true,
    ['fbi'] = true,
    ['offfbi'] = true,
    ['cia'] = true,
    ['offcia'] = true,
    ['cid'] = true,
    ['offcid'] = true,
    ['doa'] = true,
    ['offdoa'] = true,
    ['marshal'] = true,
    ['offmarshal'] = true,
}

blackListedItems = {
    'mythic',
}

blackListSearch = {
    kit50 = true,
    kit100 = true,
    kittire = true,
    cleaner = true,
    adrenaline = true,
    medikit2 = true,
    bandage2 = true,
    jack = true,
}

canSearchJob = {
    police = true,
    fbi = true,
    sheriff = true,
    mt = true,
    cia = true,
    cid = true,
    doa = true,
    marshal = true,
}

blackListWorldSearch = {
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
    [17] = true,
    [18] = true,
    [19] = true,
    [20] = true,
    [21] = true,
    [22] = true,
    [23] = true,
    [24] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
    [90] = true,
    [96] = true,
    [97] = true,
    [98] = true,
    [99] = true,
}

bag = {41, 0}

reservedSlotForWeapon = 3
config.attachments = {
    clip = true,
    eclip = true,
    dclip = true,
    silencer = true,
    flashlight = true,
    grip = true,
    scope = true,
    yusuf = true,
}

blackListWorldSwapWeapon = {
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [16] = true,
    [17] = true,
    [18] = true,
    [19] = true,
    [20] = true,
    [21] = true,
    [22] = true,
    [23] = true,
    [24] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
}

tintLabel = {
    [1] = 'Sabz',
    [2] = 'Talee',
    [3] = 'Surati',
    [4] = 'Cream',
    [5] = 'Meshki',
    [6] = 'Nareji',
    [7] = 'Plat',
}