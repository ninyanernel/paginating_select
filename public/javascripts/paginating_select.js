/* Used for displayOptions() */
function findPos(obj){
  var curleft = 0;
  var curtop = 0;

  if(obj.offsetParent){
    while(1){
     curleft += obj.offsetLeft;
     curtop += obj.offsetTop;
     if(!obj.offsetParent)
       break;
     obj = obj.offsetParent;
    }
  }
  else if(obj.x)
    curleft += obj.x;
  else if(obj.y)
    curtop += obj.y;

  return [curtop, curleft];
}

/* Hides/Unhides Options */
function display_options(div_id, img_div){
  items = document.getElementsByClassName('tip-div')

  var i=0;
  var pos = [];
  for(i=0; i<items.length;i++){
    if (items[i].id != div_id)
      items[i].style.display = 'none';
  }

  icon = document.getElementById(img_div);
  tip  = document.getElementById(div_id);

  pos = findPos(icon);

  tip.style.top  = pos[0] + 1 + 'px';
  tip.style.left = pos[1] + 24 + 'px';
  /* tip.style.top  = icon.offsetTop + 10 + 'px'; */
  /* tip.style.left = icon.offsetLeft + 20 + 'px'; */
  tip.style.display = (tip.style.display=='none')? 'block': 'none';
}

/* Sets selected radio_button as checked */
function setRadioButtons(options_id, text_id ){
  var buttons = document.getElementById(options_id).getElementsByTagName('input');
  var text = document.getElementById(text_id)
  if (text != null)
  {
    for(var i=0; i<buttons.length;i++)
    {
      if (text.value == buttons[i].value)
      {
        buttons[i].checked = true;
      }
    }
  }
}
