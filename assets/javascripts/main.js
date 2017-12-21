$(function() {
    $('.draft__hero--select .close').on('click', function(e){
        $('.draft__hero--select').addClass('hidden');
    });

    $('.draft__ban--item, .draft__hero--item').on('click', function(e){
        $('.draft__hero--select').removeClass('hidden');
    });

    $('.draft__hero--select button').on('click', function(e){
        var pick = $('.draft__hero--select select').val();
        if (!pick) return false;

        $.get('/draft/pick/' + pick).done(function(){
            location.reload();
        });
    });

    var heroSlugs = _.pluck(heroes, 'slug');
    var heroNames = _.pluck(heroes, 'name');

    _.each(heroNames, function(name, index){
        var option = $('<option/>');
        option.attr({ 'value': heroSlugs[index] }).text(name);
        $('select').append(option);
    });

    //_.filter(heroes, function(hero){ if (hero.slug.indexOf('za') !== -1) return true; });
    //_.find(heroes, function(hero){ if (hero.slug.indexOf('za') !== -1) return true; });
});