(function(){$(document).on("turbolinks:load",function(){return console.log("mail ready"),$(".new-mail").click(function(){return $(".mail-receiver").html(""),$(".mail-detail").html("")}),$(".mail-receiver").change(function(){return console.log("changed"),$.get("/search_user_name.json?search="+$(this).val(),function(e){var r,n,i,l,c;for(console.log(e),r="",c=e.names,n=0,i=c.length;n<i;n++)l=c[n],r+="<div class='receiver-name'>"+l+"</div>";return $(".receivers").html(r),$(".receiver-name").each(function(){return $(this).click(function(){return $(".mail-receiver").val($(this).html()),$(".receivers").html("")})})})}),$(".mail-send").click(function(){return $.post("/new_mail.json",{mail_detail:$(".mail-detail").val(),receiver_name:$(".mail-receiver").val()},function(e,r){return"success"===r?alert(e.message):alert("error!")})})})}).call(this);