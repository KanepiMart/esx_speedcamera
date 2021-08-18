$(function() {
    const Sound = new Audio('speedcamera.ogg');
    Sound.volume = 0.5; // 0.0 - 1.0;

    window.addEventListener('message', function(event) {
        switch(event.data.type) {
            case 'openSpeedcamera':
                $('body').show(); Sound.play()
            break;

            case 'closeSpeedcamera':
                $('body').hide();
            break;
        }
    });
});