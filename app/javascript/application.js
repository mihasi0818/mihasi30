// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
// = require semantic-ui
//= link posts.js
//= link posts2.js
//= link posts3.js

function countdown() {
    // 現在の日時を取得
    var now = new Date();
  
    // カウントダウン終了日時を設定（45日後）
    var end = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 45);
  
    // カウントダウンの残り時間を計算
    var remainingTime = end - now;
  
    // 残りの日数、時間、分、秒を計算
    var days = Math.floor(remainingTime / (1000 * 60 * 60 * 24));
    var hours = Math.floor((remainingTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    var minutes = Math.floor((remainingTime % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((remainingTime % (1000 * 60)) / 1000);
  
    // カウントダウン表示を更新
    var countdownElement = document.getElementById("countdown");
    countdownElement.innerHTML = "Remaining Time: " + days + " days, " + hours + " hours, " + minutes + " minutes, " + seconds + " seconds";
  
    // 1秒ごとにカウントダウンを更新
    setTimeout(countdown, 1000);
  }
  
  // カウントダウンを開始
  countdown();
  
