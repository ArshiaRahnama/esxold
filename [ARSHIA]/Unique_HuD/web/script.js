var kosi = false;
var vv= 0;
window.addEventListener('message', function (event) {
    try {
        switch(event.data.action) {				
            case 'updateInfo':
                $("#prof").attr("src", event.data.prof)
                $(`#money`).html(event.data.money+' $');
                $(`#coin`).html(event.data.coin+' QC');
                $(`#bank`).html(event.data.bank+' B');
                $(`#name`).html(event.data.name + " [" +  " " + event.data.id + " " +"]");
                $(`#job`).html(event.data.job + " - " + event.data.jobg);
                $(`#gang`).html(event.data.gang + " - " + event.data.gangg);
                $('#healb').css('width', event.data.health+'%');
                $('#armorb').css('width', event.data.armorx+'%');
                $('#foodb').css('width', event.data.food+'%');
                $('#waterb').css('width', event.data.water+'%');
                a.innerHTML = event.data.health + "%";
                bx.innerHTML = event.data.armor + "%";
                c.innerHTML = event.data.food + "%";
                d.innerHTML = event.data.water + "%";
                $('#stime').html(event.data.time);
            break;
            case 'disable':
                $("#head").fadeOut(0)
                $("#body").fadeOut(0)
                $("#prof").fadeOut(0)
                $("#heal").fadeOut(0)
                $("#armor").fadeOut(0)
                $("#food").fadeOut(0)
                $("#water").fadeOut(0)
            break;
            case 'enable':
                $("#head").fadeIn(100)
                $("#body").fadeIn(100)
                $("#prof").fadeIn(100)
                $("#heal").fadeIn(100)
                $("#armor").fadeIn(100)
                $("#food").fadeIn(100)
                $("#water").fadeIn(100)
            break;
            case 'kostala':
              var screenHeight = window.innerHeight;
              console.log(screenHeight);
                if (kosi == false) {
                  if (screenHeight == 720) {
                    vv = -80;
                    aa("#body", -300)
                    aa("#food", vv)
                    aa("#water", vv)
                    aa("#heal", vv)
                    aa("#armor", vv)
                  } else if (screenHeight == 900) {
                    vv = -100;
                    aa("#body", -300)
                    aa("#food", vv)
                    aa("#water", vv)
                    aa("#heal", vv)
                    aa("#armor", vv)
                } else if (screenHeight == 1080) {
                  vv = -120;
                  aa("#body", -300)
                  aa("#food", vv)
                  aa("#water", vv)
                  aa("#heal", vv)
                  aa("#armor", vv)
                } else if (screenHeight == 1440) {
                  vv = -150;
                  aa("#body", -300)
                  aa("#food", vv)
                  aa("#water", vv)
                  aa("#heal", vv)
                  aa("#armor", vv)
                } else {
                  vv = -90;
                  aa("#body", -300)
                  aa("#food", vv)
                  aa("#water", vv)
                  aa("#heal", vv)
                  aa("#armor", vv)
                }
                    kosi = true
                } else {
                    aax("#body", 0)
                    aax("#food", 0)
                    aax("#water", 0)
                    aax("#heal", 0)
                    aax("#armor", 0)
                    kosi = false
                }
            break;
        }
} catch(err) {}
});

function aa(vv, xx){
    anime({
        targets: vv,
        translateY: xx,
        delay: 100
      });
      if (vv != "#body") {
        $(vv).css('border-radius', '0.3vw');
        $(vv+"b").css('border-radius', '0.3vw');
        $("#head").css('border-radius', '0.3vw');
      }
    //   setTimeout(() => {
    //     $(vv).hide()
    //   }, 117);
}

function aax(vv, xx){
    anime({
        targets: vv,
        translateY: xx,
        delay: 100
      });
      if (vv != "#body") {
        $(vv).css('border-radius', '0.8vw');
        $(vv+"b").css('border-radius', '0.8vw');
        $("#head").css('border-radius', '0.8vw');
      }
    //   setTimeout(() => {
    //     $(vv).hide()
    //   }, 117);
}
