String.prototype.trim = function() {
  return this.replace(/^\s+|\s+$/g,"");
}

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

/* Sets selected check_boxes as checked */
function setCheckboxes(options_id, text_id ){
  var boxes = document.getElementById(options_id).getElementsByTagName('input');
  var text = document.getElementById(text_id)
  if (text != null)
  {
    var tmp = text.value.split(";").without("").compact();
    var textArray = new Array();

    for(var k=0;k<tmp.length;k++)
    {
      textArray[k] =  tmp[k].trim();
    }

    for(var i=0; i<boxes.length;i++)
    {
      boxes[i].checked = false;
      for (var j=0;j<textArray.length;j++)
      {
        if (textArray[j] == boxes[i].value)
        {
          boxes[i].checked = true;
        }
      }
    }
  }
}

function updateTextMultiple(options_id, text_id)
{
  var boxes = document.getElementById(options_id).getElementsByTagName('input');
  var text = document.getElementById(text_id);
  var boxArray = new Array();
  var count = 0;
  var tmp = text.value.split(";").without("").compact();
  var textArray = new Array();
  var textValue = new Array();

  for(var k=0;k<tmp.length;k++)
  {
    textArray[k] =  tmp[k].trim();
  }
  for(var i=0; i<boxes.length;i++)
  {
    if (boxes[i].checked)
    {
      // update boxArray
      boxArray[count] = boxes[i].value;
      count++;
    }
    else
    {
      var arr_count = textArray.length;
      for (var j=0; j<arr_count;j++)
      {
        if (boxes[i].value == textArray[j])
        {
          // remove text from textArray
          textArray = textArray.without(textArray[j])
        }
      }
    }
  }
  /* [ar.uniq().join(';'),ab.uniq().join(';')].join(";") */
  textValue  = textArray.concat(boxArray).uniq();
  text.value = textValue.join(";");
}
