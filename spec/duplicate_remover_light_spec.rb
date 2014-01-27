# coding: utf-8
require "duplicate_remover"
require "book_creator"
require "spec_helper_light"
require "duplicate_optimizer"

describe DuplicateRemover do
  include HelpersLight

  before do

    @urls_d = [
      "http://www.zyciejestpiekne.eu/index.php/7-rzeczy-ktore-musisz-zrobic-studiach/",
      "http://www.zyciejestpiekne.eu/index.php/wczesne-wstawanie-regulujemy-organizm/",
      "http://www.zyciejestpiekne.eu/index.php/gdzie-ruszam-w-2014-roku/",
      "http://www.zyciejestpiekne.eu/index.php/jak-sie-pakowac-niczego-nie-zapomniec/",
      "http://www.zyciejestpiekne.eu/index.php/lekcja-biznesu-od-nowojorskiego-taksowkarza/",
      "http://www.zyciejestpiekne.eu/index.php/autostopowa-chorwacja-zobacz-film/",
      "http://www.zyciejestpiekne.eu/index.php/5-patentow-na-przyjemne-loty/",
      "http://www.zyciejestpiekne.eu/index.php/5-denerwujacych-zachowan-pasazerow-samolotow/",
      "http://www.zyciejestpiekne.eu/index.php/szybki-wypad-do-holandii-zdjecia/",
      "http://www.zyciejestpiekne.eu/index.php/autentyczne-autostopowe-historie/",
      "http://www.zyciejestpiekne.eu/index.php/sprzedawanie-sie/",
      "http://www.zyciejestpiekne.eu/index.php/chillout-w-podrozy-rozwiazanie-konkursu/",
      "http://www.zyciejestpiekne.eu/index.php/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji/",

      "http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/wczesne-wstawanie-regulujemy-organizm//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/jak-sie-pakowac-niczego-nie-zapomniec//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/lekcja-biznesu-od-nowojorskiego-taksowkarza//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/autostopowa-chorwacja-zobacz-film//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/5-patentow-na-przyjemne-loty//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/5-denerwujacych-zachowan-pasazerow-samolotow//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/szybki-wypad-do-holandii-zdjecia//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/autentyczne-autostopowe-historie//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/sprzedawanie-sie//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/chillout-w-podrozy-rozwiazanie-konkursu//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/projekt-maraton-czesc-i//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/jak-motywowac-sie-do-biegania//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/projekt-maraton-zakonczony//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/ucisz-wewnetrzny-glos//#disqus_thread/",
      "http://www.zyciejestpiekne.eu/dzien-ktory-przejdzie-do-historii//#disqus_thread/",

      "http://www.zyciejestpiekne.eu/index.php/projekt-maraton-czesc-i/",
      "http://www.zyciejestpiekne.eu/index.php/jak-motywowac-sie-do-biegania/",
      "http://www.zyciejestpiekne.eu/index.php/projekt-maraton-zakonczony/",
      "http://www.zyciejestpiekne.eu/index.php/ucisz-wewnetrzny-glos/",
      "http://www.zyciejestpiekne.eu/index.php/dzien-ktory-przejdzie-do-historii/",

      

      "http://www.zyciejestpiekne.eu/misz-masz/",
    ]

    @urls_o = [
      "http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach/",
      "http://www.zyciejestpiekne.eu/wczesne-wstawanie-regulujemy-organizm/",
      "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
      "http://www.zyciejestpiekne.eu/jak-sie-pakowac-niczego-nie-zapomniec/",
      "http://www.zyciejestpiekne.eu/lekcja-biznesu-od-nowojorskiego-taksowkarza/",
      "http://www.zyciejestpiekne.eu/autostopowa-chorwacja-zobacz-film/",
      "http://www.zyciejestpiekne.eu/5-patentow-na-przyjemne-loty/",
      "http://www.zyciejestpiekne.eu/5-denerwujacych-zachowan-pasazerow-samolotow/",
      "http://www.zyciejestpiekne.eu/szybki-wypad-do-holandii-zdjecia/",
      "http://www.zyciejestpiekne.eu/autentyczne-autostopowe-historie/",
      "http://www.zyciejestpiekne.eu/sprzedawanie-sie/",
      "http://www.zyciejestpiekne.eu/chillout-w-podrozy-rozwiazanie-konkursu/",
      "http://www.zyciejestpiekne.eu/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji/",

      "http://www.zyciejestpiekne.eu/projekt-maraton-czesc-i/",
      "http://www.zyciejestpiekne.eu/jak-motywowac-sie-do-biegania/",
      "http://www.zyciejestpiekne.eu/projekt-maraton-zakonczony/",
      "http://www.zyciejestpiekne.eu/ucisz-wewnetrzny-glos/",
      "http://www.zyciejestpiekne.eu/dzien-ktory-przejdzie-do-historii/",
    ]



    
    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/zyciejestpiekne/o", {valid_page: true, links_num: 3})
    subpages += create_subpages(@urls_d, "spec/files/zyciejestpiekne/d", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://www.zyciejestpiekne.eu/", subpages: subpages)

    @optimizer = DuplicateOptimizer.new(@website)
    @subpages = DuplicateRemover.remove(@website.subpages, @optimizer)
  end


  it "should optimize during duplicate removing" do
    expect(@optimizer.duplicate?("http://www.zyciejestpiekne.eu/index.php/7-rzeczy-ktore-musisz-zrobic-studiach/")).to eq(true)
    expect(@optimizer.duplicate?("http://www.zyciejestpiekne.eu/szybki-wypad-do-holandii-zdjecix//#disqus_thread/")).to eq(true)

    @urls_o.each {|url| expect(@subpages.map{|x| x.url}).to include(url)}
    expect(@urls_o.count).to eq(@subpages.count)
  end




  
end