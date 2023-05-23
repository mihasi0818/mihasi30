
function animateCountdownDigit(digitElement, newValue) {
    digitElement.style.transform = "scale(0.8)";
    setTimeout(function() {
      digitElement.textContent = newValue;
      digitElement.style.transform = "scale(1)";
    }, 500);
  }
  
  function countdown() {
    var targetDate = new Date();
    targetDate.setDate(targetDate.getDate() + 45);
  
    var daysElement = document.getElementById("days");
    var hoursElement = document.getElementById("hours");
    var minutesElement = document.getElementById("minutes");
    var secondsElement = document.getElementById("seconds");
  
    setInterval(function() {
      var currentDate = new Date();
      var diff = targetDate - currentDate;
  
      var days = Math.floor(diff / (1000 * 60 * 60 * 24));
      var hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
      var minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((diff % (1000 * 60)) / 1000);
  
      animateCountdownDigit(daysElement, days);
      animateCountdownDigit(hoursElement, hours);
      animateCountdownDigit(minutesElement, minutes);
      animateCountdownDigit(secondsElement, seconds);
    }, 1000);
  }
  
  countdown();
  