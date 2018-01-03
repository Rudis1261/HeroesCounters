$(function() {
    $('.draft__hero--select .close').on('click', function(e){
        $('.draft__hero--select').addClass('hidden');
    });

    $('.draft__ban--item, .draft__hero--item').on('click', function(e){
        if ($(this).attr('disabled') == 'disabled') {
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
        $('.draft__hero--select').removeClass('hidden');
    });

    $('#search').on('keyup', function(){
        var search = $(this).val();
        var elements = $('[data-type="hero-pick"]');
        var matches = _.filter(elements, function(element){
          if ($(element).data('value').indexOf(search) !== -1) return true;
        });

        elements.hide();
        if (matches.length == 0 || search == '') {
            $('[data-type="hero-pick"]').show();
        } else {
            $(matches).show();
        }
    });


    $('[data-type="class-pick"]').on('click', function(){
        var value = $(this).data('value');
        if (document.activeClass && document.activeClass == value) {
            document.activeClass = null;
            $('[data-type="hero-pick"]').show();
            return false;
        }

        document.activeClass = value;
        var elements = $('[data-type="hero-pick"]');
        var matches = _.filter(elements, function(element){
            if ($(element).data('class').indexOf(value) !== -1) return true;
        });

        elements.hide();
        if (matches.length == 0 || search == '') {
            $('[data-type="hero-pick"]').show();
        } else {
            $(matches).show();
        }
    });

    var heroSlugs = _.pluck(heroes, 'slug');
    var heroNames = _.pluck(heroes, 'name');

    _.each(heroNames, function(name, index){
        var option = $('<option/>');
        option.attr({ 'value': heroSlugs[index] }).text(name);
        $('select').append(option);
    });
});