$(document).ready(function() {
  //table sort
  $(document).on('click', '.head', function() {
      let table = $(this).parents('.table').eq(0);
      let rows = table.find('.tbody .row').toArray().sort(comparer($(this).index()));
      this.asc = !this.asc;
      if (!this.asc) { rows = rows.reverse(); }
      table.children('.tbody').empty().html(rows)
  });
  function comparer(index) {
      return function(a, b) {
          let valA = getCellValue(a, index),
              valB = getCellValue(b, index);
          return $.isNumeric(valA) && $.isNumeric(valB) ?
              valA - valB : valA.localeCompare(valB);
      };
  }
  function getCellValue(row, index) {
      return $(row).find(`.box:eq(${index})`).text()
  }

  let search_index;
  let rows = $('.table').find('.tbody .row').toArray();

  //table search
  $('.head').on('dblclick', function(e) {
      search_index = $(this).index()

      if (!$('.searchbox').is(":focus") && search_index !== 0){
          $(`.thead span:eq(${search_index})`).hide()
          if (search_index >= 3){
              $("<input class='searchbox' type='text' placeholder='大於'>").appendTo(this).focus();
          } else{
              $("<input class='searchbox' type='text' placeholder='請輸入關鍵字'>").appendTo(this).focus();
          }
      }
  });
  $(document).on('focusout','.searchbox', function () {
      let $this = $(this);
      if ($('.searchbox').val() === ""){
          $(`.thead span`).show()
          $('.thead').find('.searchbox').remove();
      }
  });
  $(document).on('keyup','.searchbox', function () {
      let search_text = $(this).val()
      $('.table').children('.tbody').empty().html(findresults(search_text))
  });
  function findresults(search_text){
      if ($.isNumeric(getCellValue(rows[0], search_index))){
          return results = rows.filter(x => getCellValue(x, search_index) > Number(search_text))
      }
      else{
          return results = rows.filter(x => getCellValue(x, search_index).toLowerCase().match(search_text))
      }
  };
})
