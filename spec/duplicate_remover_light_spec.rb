# coding: utf-8
require "duplicate_remover"
require "book_creator"
require "spec_helper_light"
require "duplicate_optimizer"

describe DuplicateRemover do
  include HelpersLight


  it "should optimize during duplicate removing" do
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
    subpages += create_subpages(@urls_d, "spec/files/zyciejestpiekne/d", {valid_page: true, links_num: 0})
    @website = create_website(base_url: "http://www.zyciejestpiekne.eu/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove
    @subpages.each{|subpage| p subpage.url}

    @urls_o.each {|url| expect(@subpages.map{|x| x.url}).to include(url)}
    expect(@subpages.count).to eq(@urls_o.count)
  end


  it "should remove only duplicate" do
    @urls_o = [
      "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
      "http://dokturjazon.blox.pl/2011/03/Dwie-strony-rzeki-i-medalu.html",
      "http://dokturjazon.blox.pl/2010/07/Garsc-zasad.html",
      "http://dokturjazon.blox.pl/2010/02/Polska-inwazja.html",
      "http://dokturjazon.blox.pl/2010/05/Niedziela.html",
      "http://dokturjazon.blox.pl/2010/05/Zimno-zimniej.html",
      "http://dokturjazon.blox.pl/2010/05/Szczescie.html",
    ]

    @urls_d = [
      "http://dokturjazon.blox.pl/2011/03/Dwie-strony-rzeki-i-medalu.rss",
      "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.rss",
      "http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?1,2010",
      "http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?2,2011",
      "http://dokturjazon.blox.pl/2010/09/Czas-zakonczyc-te-niesamowita-karuzele-ten.rss",
      "http://dokturjazon.blox.pl/2010/07/Cisza-spokoj-gory.rss",
      "http://dokturjazon.blox.pl/2010/07/Garsc-zasad.rss",
      "http://dokturjazon.blox.pl/html/1310721,262146,169.html?2",
      "http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?4,2010",
    ]

    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/jazon/o", {valid_page: true, links_num: 3})
    subpages += create_subpages(@urls_d, "spec/files/jazon/d", {valid_page: true, links_num: 1})
    @website = create_website(base_url: "http://dokturjazon.blox.pl/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "


    expect(@subpages.count).to eq(@urls_o.count)
  end

  it "should remove all duplicates, not original" do

    @urls_o = [
      "http://linielotnicze.blox.pl/",
      "http://linielotnicze.blox.pl/html",
      "http://linielotnicze.blox.pl/html/1310721,262146,724.html?1",
      "http://linielotnicze.blox.pl/html/1310721,262146,17.html?2",
      "http://linielotnicze.blox.pl/html/1310721,262146,18.html?1",
      "http://linielotnicze.blox.pl/html/1310721,262146,19.html?2",
      "http://linielotnicze.blox.pl/html/1310721,262146,725.html?1",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?7",
      "http://linielotnicze.blox.pl/tagi_b/10925/samolot.html",
      "http://linielotnicze.blox.pl/tagi_b/17901/samoloty.html",
      "http://linielotnicze.blox.pl/tagi_b/33760/strajk.html",
      "http://linielotnicze.blox.pl/tagi_b/2722/Szkocja.html",
      "http://linielotnicze.blox.pl/tagi_b/17634/tanie-linie.html",
      "http://linielotnicze.blox.pl/tagi_b/49525/tanie-linie-lotnicze.html",
      "http://linielotnicze.blox.pl/tagi_b/176/Warszawa.html",
      "http://linielotnicze.blox.pl/tagi_b/29847/WizzAir.html",
      "http://linielotnicze.blox.pl/html/1310721,262146,21.html?1441304",
      "http://linielotnicze.blox.pl/html/1310721,262146,21.html?1441303",
      "http://linielotnicze.blox.pl/html/1310721,262146,21.html?1441312",
      "http://linielotnicze.blox.pl/rss2",
      "http://linielotnicze.blox.pl/2014/03/Ryanair-otwiera-baze-w-Brukseli.html",
      "http://linielotnicze.blox.pl/2014/02/James-Smith-McDonnell.html",
      "http://linielotnicze.blox.pl/2014/02/Wybieramy-sie-do-Londynu-na-wycieczke.html",
      "http://linielotnicze.blox.pl/2014/02/Holly-i-Graham.html",
      "http://linielotnicze.blox.pl/2014/02/Podroze-odwiecznych-tematem-fascynacji.html",
      "http://linielotnicze.blox.pl/2013/05/Easyjet-z-Southend-do-Edynburga.html",
      "http://linielotnicze.blox.pl/2013/04/Ethiopian-Airlines-wznowil-loty-Dreamlinerow.html",
      "http://linielotnicze.blox.pl/html/1310721,262146,169.html?2",
      "http://linielotnicze.blox.pl/html/1310721,262146,169.html?3",
      "http://linielotnicze.blox.pl/html/1310721,262146,169.html?4",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?1,1",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?18",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?20",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?22",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?28",
      "http://linielotnicze.blox.pl/2012/12/Kolejna-baza-Ryanair-w-Europie.html",
      "http://linielotnicze.blox.pl/2012/12/Lotnisko-w-Lublinie-pierwsze-loty.html",
      "http://linielotnicze.blox.pl/2012/12/Nowe-loty-easyJet-z-Londynu.html",
      "http://linielotnicze.blox.pl/2012/12/Od-IATA.html",
      "http://linielotnicze.blox.pl/2012/12/Iberia-negocjuje.html",
      "http://linielotnicze.blox.pl/html/1310721,262146,17.html?3",
      "http://linielotnicze.blox.pl/html/1310721,262146,19.html?3",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?10",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?17",
      "http://linielotnicze.blox.pl/html/1310721,262146,20.html?21",
      "http://linielotnicze.blox.pl/2013/01/Alitalia-sezon-zimowy-aktualizacje.html",
      "http://linielotnicze.blox.pl/2013/02/Malaysia-Airlines-w-sojuszu-Oneworld.html",
      "http://linielotnicze.blox.pl/2013/04/Rusza-prace-na-lotnisku-Balice.html",
      "http://linielotnicze.blox.pl/2013/01/Z-szoferem-z-lotniska-Etihad.html",
      "http://linielotnicze.blox.pl/2013/02/Jednak-strajk-pracownikow-Iberia.html",
      "http://linielotnicze.blox.pl/2013/04/Norwegian-poleci-na-Ibize-z-Londynu-Gatwick.html",
      "http://linielotnicze.blox.pl/2013/04/Kosmiczna-oferta-KLM.html",
      "http://linielotnicze.blox.pl/2013/03/Siedz-z-kim-chcesz.html",
      "http://linielotnicze.blox.pl/2013/01/Tanie-linie-w-Lublinie.html",
      "http://linielotnicze.blox.pl/2013/03/Ruszy-naprawa-pasa-w-Modlinie.html",
      "http://linielotnicze.blox.pl/2013/01/Ryanair-bije-rekordy.html",
      "http://linielotnicze.blox.pl/html?mobile=no",
      "http://linielotnicze.blox.pl/html/1310721,262146,21.html?0",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?10231342",
      "http://linielotnicze.blox.pl/2014/03/Ryanair-otwiera-baze-w-Brukseli.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?10190168",
      "http://linielotnicze.blox.pl/2014/02/James-Smith-McDonnell.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?10181732",
      "http://linielotnicze.blox.pl/2014/02/Wybieramy-sie-do-Londynu-na-wycieczke.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?10179544",
      "http://linielotnicze.blox.pl/2014/02/Holly-i-Graham.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?10166306",
      "http://linielotnicze.blox.pl/2014/02/Podroze-odwiecznych-tematem-fascynacji.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9468111",
      "http://linielotnicze.blox.pl/2013/05/Easyjet-z-Southend-do-Edynburga.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9456084",
      "http://linielotnicze.blox.pl/2013/04/Ethiopian-Airlines-wznowil-loty-Dreamlinerow.rss",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?2,-1",
      "http://linielotnicze.blox.pl/html/1310721,262146,169.html?1",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?2,1",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?3,-1",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?3,1",
      "http://linielotnicze.blox.pl/html/1310721,262146,169,170.html?4,-1",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9179148",
      "http://linielotnicze.blox.pl/2012/12/Kolejna-baza-Ryanair-w-Europie.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9166816",
      "http://linielotnicze.blox.pl/2012/12/Lotnisko-w-Lublinie-pierwsze-loty.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9163207",
      "http://linielotnicze.blox.pl/2012/12/Nowe-loty-easyJet-z-Londynu.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9158521",
      "http://linielotnicze.blox.pl/2012/12/Od-IATA.rss",
      "http://linielotnicze.blox.pl/2012/12/Iberia-negocjuje.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9190039",
      "http://linielotnicze.blox.pl/2013/01/Alitalia-sezon-zimowy-aktualizacje.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9262483",
      "http://linielotnicze.blox.pl/2013/02/Malaysia-Airlines-w-sojuszu-Oneworld.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9394122",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9430085",
      "http://linielotnicze.blox.pl/2013/04/Kosmiczna-oferta-KLM.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9380251",
      "http://linielotnicze.blox.pl/2013/03/Siedz-z-kim-chcesz.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9250842",
      "http://linielotnicze.blox.pl/2013/01/Tanie-linie-w-Lublinie.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9343572",
      "http://linielotnicze.blox.pl/2013/03/Ruszy-naprawa-pasa-w-Modlinie.rss",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9238880",
      "http://linielotnicze.blox.pl/2013/01/Ryanair-bije-rekordy.rss",
      "http://linielotnicze.blox.pl/html/",
      "http://linielotnicze.blox.pl/html?mobile=yes",
      "http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9158492",
    ]

    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/linielotnicze/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://linielotnicze.blox.pl/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.map{|x| x.url}).to include("http://linielotnicze.blox.pl/2013/02/Jednak-strajk-pracownikow-Iberia.html")
    expect(@subpages.map{|x| x.url}).to include("http://linielotnicze.blox.pl/2014/03/Ryanair-otwiera-baze-w-Brukseli.html")
    expect(@subpages.map{|x| x.url}).should_not include("http://linielotnicze.blox.pl/html/4259841,1179650,217.html?9238880")

    # TODO: removing duplicates not work at all!!! :(
  end

  it "should find correct duplicate" do
    @urls_o = [
      "http://linielotnicze.blox.pl/",
      "http://linielotnicze.blox.pl/2014/02/Holly-i-Graham.html",
    ]

    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/linielotnicze_duplicate/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://linielotnicze.blox.pl/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.count).to eq(1)
    expect(@subpages.map{|x| x.url}).to include("http://linielotnicze.blox.pl/2014/02/Holly-i-Graham.html")
    expect(@subpages.map{|x| x.url}).should_not include("http://linielotnicze.blox.pl/")
  end

  it "should find correct duplicates in jazon" do
    @urls_o = [
      "http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?4,2010",
      "http://dokturjazon.blox.pl/2010/05/Niedziela.html",
    ]

    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/jazon_duplicate/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://dokturjazon.blox.pl/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.count).to eq(1)
    expect(@subpages.map{|x| x.url}).to include("http://dokturjazon.blox.pl/2010/05/Niedziela.html")
    expect(@subpages.map{|x| x.url}).should_not include("http://dokturjazon.blox.pl/html/1310721,262146,14,15.html?4,2010")
  end


  it "should remove proper duplicate from zjp" do
    @urls_o = [
      "http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach/",
      "http://www.zyciejestpiekne.eu/ulepszaniesiebie/",

    ]

    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/zjp_duplicate1/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://www.zyciejestpiekne.eu/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.count).to eq(1)
    expect(@subpages.map{|x| x.url}).to include("http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach/")
    expect(@subpages.map{|x| x.url}).should_not include("http://www.zyciejestpiekne.eu/ulepszaniesiebie/")

  end

  it "should remove proper duplicate from zjp" do
    @urls_o = [
      "http://spacerywirtualne.wordpress.com/2012/03/19/krpano/",
      "http://spacerywirtualne.wordpress.com/tag/krpano/", 
    ]


    subpages = []
    subpages += create_subpages(@urls_o, "spec/files/spacerywirtualne_duplicate/o", {valid_page: true, links_num: 3})
    @website = create_website(base_url: "http://spacerywirtualne.wordpress.com/", subpages: subpages)
    @duplicate_remover = DuplicateRemover.new(@website)
    @subpages = @duplicate_remover.remove

    p " "
    expect(@subpages.count).to eq(1)
    expect(@subpages.map{|x| x.url}).to include("http://spacerywirtualne.wordpress.com/2012/03/19/krpano/")
    expect(@subpages.map{|x| x.url}).should_not include("http://spacerywirtualne.wordpress.com/tag/krpano/")

  end

end