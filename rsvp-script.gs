var html = HtmlService.createHtmlOutputFromFile('bryandrach.html');


function doGet() {
  return html
}

function addNewItem(form_data)
{
  var sheet = SpreadsheetApp.getActive().getSheetByName('Sheet1');
  
  sheet.appendRow([form_data.name, form_data.church_wedding, form_data.church_pax, form_data.wedding_dinner, form_data.dinner_pax, form_data.comments]);
  
  
}
