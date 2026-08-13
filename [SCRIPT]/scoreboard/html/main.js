const ResourceName = "scoreboard"
var intervalrob;
var timerint;
let JeweleryCd = false;
let BankCd = false;
let shopCd = false;
let CargoCd = false;
let BimehCd = false;
let SheriffBankCd = false;
let FelecaCd = false;
let MinibankCd = false;
let JewelerySheriffCd = false;
let mythicCd = false;
let closeKeys = [8, 27];
const InfoRobberys = {
	shop: {
		name: "shop",
		img: './images/Assets/Shop1.jpg',
		Info: "سرقت از فروشگاه | 2 نفر رابر ، 2 نفر پلیس | فقط با پیستول | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	Bank: {
		name: "Bank",
		img: './images/Assets/bank.jpg',
		Info: "سرقت از بانک مرکزی | 8 نفر رابر ، 8 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	SheriffBank: {
		name: "SheriffBank",
		img: "./images/Assets/banksheriff.jpg",
		Info: "سرقت از بانک شریف | 6 نفر رابر ، 6 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	Cargo: {
		name: "Cargo",
		img: "./images/Assets/cargo.jpg",
		Info: "سرقت اسلحه کارگو | 8 نفر رابر ، 8 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	Bimeh: {
		name: "Bimeh",
		img: "./images/Assets/bimeh.jpg",
		Info: "سرقت از شرکت بیمه | 7 نفر رابر ، 7 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	jewelery: {
		name: "jewelery",
		img: "./images/Assets/jewellery.jpg",
		Info: "سرقت از جواهری | 4 نفر رابر ، 4 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	Feleca: {
		name: "Feleca",
		img: "./images/Assets/banksahel.jpg",
		Info: "سرقت از بانک ساحل | 6 نفر رابر ، 6 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	Minibank: {
		name: "Minibank",
		img: "./images/Assets/minibank.jpg",
		Info: "سرقت از بانک کوچک | 4 نفر رابر ، 4 نفر پلیس | فقط با پیستول | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	JewelerySheriff: {
		name: "JewelerySheriff",
		img: "./images/Assets/jewellery2.jpg",
		Info: "سرقت از جواهری | 4 نفر رابر ، 4 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
	mythic: {
		name: "mythic",
		img: "./images/Assets/mythic.jpg",
		Info: "سرقت از میتیک | 10 نفر رابر ، 10 نفر پلیس | قبل از سرقت حتما قوانین شهری را مطالعه بفرمایید",
	},
}

// اضافه کردن Event Listener برای کلید F10
window.addEventListener("keydown", function(event) {
    if (event.keyCode === 121) { // کد کلید F10
        event.preventDefault(); // جلوگیری از رفتار پیش‌فرض مرورگر
        $('#wrap').fadeIn(); // نمایش منو
    }
});
window.addEventListener("keyup", (e) => {
	if (closeKeys.includes(e.keyCode)) {
		closeui()
	}
})


window.addEventListener('message', (event) => {
	switch (event.data.action) {
		case 'toggle':
			$('#wrap').fadeIn();

			timerint = setInterval(function() {
				let strTime = new Date().toLocaleTimeString();
				$("#Clock").html(strTime)
			}, 1000)

			break;

		case 'updatetimer':
			
			if (event.data.timer > 0) {
				clearInterval(intervalrob);
			} else {
				secondsToHms(Math.abs(event.data.timer))
			}
			break;
		case 'updatePlayers':
			$('#playersnum').text(event.data.players_counts);
		
			break;

		case 'updateInfo':

			$('#playersnum').text(event.data.player_count);
			$('#Player-Clock').text(event.data.player_time);

			for (var u in event.data.robs) {
				if (event.data.robs['Bimeh'] <= 0) {
					BimehCd = true
				} else {
					BimehCd = false
				}
				if (event.data.robs['cargo'] <= 0) {
					CargoCd = true
				} else {
					CargoCd = false
				}
				if (event.data.robs['jewelery'] <= 0) {
					JeweleryCd = true
				} else {
					JeweleryCd = false
				}
				if (event.data.robs['Bank'] <= 0) {
					BankCd = true
				} else {
					BankCd = false
				}
				if (event.data.robs['shop'] <= 0) {
					shopCd = true
				} else {
					shopCd = false
				}
				if (event.data.robs['SheriffBank'] <= 0) {
					SheriffBankCd = true
				} else {
					SheriffBankCd = false
				}
				if (event.data.robs['Minibank'] <= 0) {
					MinibankCd = true
				} else {
					MinibankCd = false
				}
				if (event.data.robs['Feleca'] <= 0) {
					FelecaCd = true
				} else {
					FelecaCd = false
				}
				if (event.data.robs['JewelerySheriff'] <= 0) {
					JewelerySheriffCd = true
				} else {
					JewelerySheriffCd = false
				}
				if (event.data.robs['mythic'] <= 0) {
					mythicCd = true
				} else {
					mythicCd = false
				}
			}
			if (event.data.data) {
				var JobData = event.data.data;
				// Robberys CoolDown
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 2, "shop", shopCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 7, "Bank", BankCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 7, "Bimeh", BimehCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 8, "Cargo", CargoCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 5, "jewelery", JeweleryCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 5, "SheriffBank", SheriffBankCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 6, "Feleca", FelecaCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 5, "Minibank", MinibankCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 5, "JewelerySheriff", JewelerySheriffCd)
				RobCd(JobData.police + JobData.sheriff + JobData.mt + JobData.fbi, 10, "mythic", mythicCd)
				// Online Jobs
				for (var k in JobData) {
					if (JobData[k] === 0) {
						$(`#${k}_input`).prop("checked", false);
					} else if (JobData[k] > 0) {
						$(`#${k}_switch`).attr("data-on", JobData[k]);
						$(`#${k}_input`).prop("checked", true);
					};
				};
			};
			break;

	}
});

function ToggleMode() {
	$("html").toggleClass("mode")
}

function closeui() {
	$('#wrap').fadeOut();
	clearInterval(intervalrob);
	clearInterval(timerint);
	$.post('http://' + ResourceName + '/close', JSON.stringify({}));
	$(".second_container").fadeOut(3000);
	$(".container").fadeIn(0);
}

function secondsToHms(d) {
	d = Number(d);
	var h = Math.floor(d / 3600);
	var m = Math.floor(d % 3600 / 60);
	var s = Math.floor(d % 3600 % 60);
	var hDisplay = h > 0 ? h + (h == 1 ? " " : " ") : "0";
	var mDisplay = m > 0 ? m + (m == 1 ? " " : " ") : "0";
	var sDisplay = s > 0 ? s + (s == 1 ? " " : " ") : "0";
	if (Number(hDisplay) > 5) {
		$("#Timer_Hour").html("00");
		$("#Timer_Minutes").html("00")
		$("#Timer_Seconds").html("00")
	} else {
		$("#Timer_Hour").html(hDisplay);
		$("#Timer_Minutes").html(mDisplay)
		$("#Timer_Seconds").html(sDisplay)
	}
}
function showJobInfo(job) {
	const jobInfo = {
	  police: {
		Name:'UniqueRP Police DepartMent',
		logo: 'images/Assets/police.png',
		description: 'police bray nejat shar 24 saate faal ast va mitavanid bray eteleat bishtar be adare police dar mission row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/gj3dRFPa',
		depImage:'./images/Assets/policedep.png'
	  },
	  sheriff: {
		Name:'UniqueRP Sheriff DepartMent',
		logo: 'images/Assets/sheriff.png',
		description: 'police bray nejat biron shar 24 saate faal ast va mitavanid bray eteleat bishtar be adare sherrif dar sany shores row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/gj3dRFPa',
		depImage:'./images/Assets/sheriffdep.jpg'
	  },
	  ambulance: {
		Name:'UniqueRP ambulance DepartMent',
		logo: 'images/Assets/medic.png',
		description: 'medic bray darman tamam sharvandan 24 saate faal ast va mitavanid bray eteleat bishtar be adare medic darmarkaz shar row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/kyXVU9yU',
		depImage:'./images/Assets/medic.jpg'
	  },
	  fbi: {
		Name:'UniqueRP FBI DepartMent',
		logo: 'images/Assets/FBI.png',
		description: 'fbi brayresidegi be tamam mojremin 24 saate faal ast va mitavanid bray eteleat bishtar be adare fbi darmarkaz shar row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/gj3dRFPa',
		depImage:'./images/Assets/fbidep.jpg'
	  },
	  mt: {
		Name:'UniqueRP Metropolitan DepartMent',
		logo: 'images/Assets/MT.png',
		description: 'MT brayresidegi be tamam mojremin 24 saate faal ast va mitavanid bray eteleat bishtar be adare mt dar vinewood row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/gj3dRFPa',
		depImage:'./images/Assets/mtdep.jpg'
	  },
	  mechanic: {
		Name:'UniqueRP Mechanic DepartMent',
		logo: 'images/Assets/mechanic.png',
		description: 'Mechanic  brayresidegi be tamam kharabia mashin 24 saate faal ast va mitavanid bray eteleat bishtar be adare MC dar centeral row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/gWXhxbgz',
		depImage:'./images/Assets/mcdep.jpg'
	  },
	  taxi: {
		Name:'UniqueRP Taxi DepartMent',
		logo: 'images/Assets/taxi.png',
		description: 'Taxi bray khadamat resani be mardom 24 saate faal ast va mitavanid bray eteleat bishtar be adare MC dar nazidiki casino row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/X4PH9ufe',
		depImage:'./images/Assets/taxidep.jpg'
	  },
	  weazel: {
		Name:'UniqueRP Weazel DepartMent',
		logo: 'images/Assets/weazelnews.png',
		description: 'weazel bray zabt hargone akhbar 24 saate faal ast va mitavanid bray eteleat bishtar be adare MC dar nazidiki markaz shar row beravid ya az tarigh dokme zir join discord job shavid',
		discordlink:'https://discord.gg/4GkAU2cj',
		depImage:'./images/Assets/weazel.jpg'
	  },
	  // Add more jobs here...
	};
  
	if (jobInfo[job]) {
		document.getElementById('jobName').innerHTML = jobInfo[job].Name.split("  ")
	  document.getElementById('jobLogo').src = jobInfo[job].logo;
	  document.getElementById('jobDescription').innerText = jobInfo[job].description;
	  document.querySelector('.overlay-content').style.backgroundImage = jobInfo[job].background;
	  document.getElementById('depimage').src = jobInfo[job].depImage
	  document.getElementById('jobInfoOverlay').style.display = 'flex';
	}
    const discordbt = document.getElementById('discord');
    discordbt.addEventListener('click', () => {
        if (jobInfo[job].discordlink) {
            navigator.clipboard.writeText('').then(() => {
                navigator.clipboard.writeText(jobInfo[job].discordlink).then(() => {
                    $("#CopydisDone").fadeIn(123);
                    setTimeout(() => {
                        $("#CopydisDone").fadeOut(123);
                    }, 2000);
                }).catch(err => {
                    console.error('Failed to copy: ', err);
                });
            }).catch(err => {
                console.error('Failed to clear clipboard: ', err);
            });
        }
    });
}	
  
function closeJobInfo() {
	document.getElementById('jobInfoOverlay').style.display = 'none';
}

function robclick(robname) {
	clearInterval(intervalrob);
	$("#Timer_Hour").html("00");
	$("#Timer_Minutes").html("00");
	$("#Timer_Seconds").html("00");
	$(".panel-overlay").fadeOut(0);
	$(".panel-overlay").fadeIn(1000);
	for (k in InfoRobberys) {
	  if (InfoRobberys[k].name == robname) {
		$("#Info_Text").html(InfoRobberys[k].Info);
		$("#Info_Image").attr("src", InfoRobberys[k].img);
		$("#Police_Count").html(InfoRobberys[k].police);
		$("#Robber_Count").html(InfoRobberys[k].robber);
		intervalrob = setInterval(function() {
		  $.post('http://' + ResourceName + '/Timer', JSON.stringify({
			rob: robname
		  }));
		}, 900);
	  }
	}
	$("#robInfoPanel").fadeIn(1000);
  }
  
  function closeRobInfo() {
	$("#robInfoPanel").fadeOut(0);
	clearInterval(intervalrob);
  }

function closeRobInfo() {
    $(".panel-overlay").fadeOut(0);
    $(".container").fadeIn(1000);
    clearInterval(intervalrob);
}
let link = 'https://discord.gg/rwBHcCqzJ';
function CopyClipBoard(link) {
	navigator.clipboard.writeText('').then(() => {
		navigator.clipboard.writeText(link).then(() => {
			$("#CopyDone").fadeIn(123);
			setTimeout(() => {
				$("#CopyDone").fadeOut(123);
			}, 2000);
		}).catch(err => {
			console.error('Failed to copy: ', err);
		});
	}).catch(err => {
		console.error('Failed to clear clipboard: ', err);
	});

}



function RobCd(cops, copsneed, namerob, cdname) {
	if (cops >= copsneed) {
		if (!cdname) {
			$('.RobStatus#' + namerob).addClass(namerob + '_active');
			$('.RobStatus#' + namerob).removeClass(namerob + '_down');
			$('.RobStatus#' + namerob).removeClass(namerob + '');
		} else {
			$('.RobStatus#' + namerob).removeClass(namerob + '_active');
			$('.RobStatus#' + namerob).addClass(namerob + '_down');
			$('.RobStatus#' + namerob).removeClass(namerob + '');
		};
	} else {
		$('.RobStatus#' + namerob).removeClass(namerob + '_active');
		$('.RobStatus#' + namerob).removeClass(namerob + '_down');
		$('.RobStatus#' + namerob).addClass(namerob + '');
	};
};
        // تابع برای نمایش بخش مربوطه
function showSection(sectionId) {
            // مخفی کردن همه بخش‌ها
            document.querySelectorAll('.content-section').forEach(function(section) {
                section.classList.remove('active');
            });

            // نمایش بخش انتخاب شده
            document.getElementById(sectionId).classList.add('active');
    }
	// تابع برای نمایش section1 به طور پیشفرض
function showDefaultSection() {
	showSection('section1');
  }
  
  // تابع برای بستن صفحه و ریست کردن بخش‌ها
  function closeui() {
	$('#wrap').fadeOut();
	clearInterval(intervalrob);
	clearInterval(timerint);
	$.post('http://' + ResourceName + '/close', JSON.stringify({}));
	$(".second_container").fadeOut(3000);
	$(".container").fadeIn(0);
  
	// ریست کردن بخش‌ها به section1
	showDefaultSection();
  }
  
  // تابع برای نمایش بخش مورد نظر
  function showSection(sectionId) {
	// مخفی کردن تمام بخش‌ها
	document.querySelectorAll('.content-section').forEach(section => {
	  section.classList.remove('active');
	});
  
	// نمایش بخش انتخاب شده
	document.getElementById(sectionId).classList.add('active');
  }
  
  // فراخوانی تابع هنگام بارگذاری صفحه
  window.onload = showDefaultSection;