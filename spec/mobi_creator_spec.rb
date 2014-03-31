# coding: utf-8
require "mobi_creator"
require "spec_helper_light"
require "spec_helper"


describe MobiCreator do
  include HelpersLight

  it "should create mobi book" do

    @jazon = [
      "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
      "http://dokturjazon.blox.pl/2011/03/Dwie-strony-rzeki-i-medalu.html",
      "http://dokturjazon.blox.pl/2010/07/Garsc-zasad.html",
      "http://dokturjazon.blox.pl/2010/02/Polska-inwazja.html",
      "http://dokturjazon.blox.pl/2010/05/Niedziela.html",
      "http://dokturjazon.blox.pl/2010/05/Zimno-zimniej.html",
      "http://dokturjazon.blox.pl/2010/05/Szczescie.html",
    ]

    @zyciejestpiekne = [
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
    subpages += create_subpages(@jazon, "spec/files/jazon/o", {valid_page: true, links_num: 3})
    subpages += create_subpages(@zyciejestpiekne, "spec/files/zyciejestpiekne/o", {valid_page: true, links_num: 3})
    title = "Example title"

    mobi_creator = MobiCreator.new(subpages, title)
    file, dir = mobi_creator.create

    debugger

    expect(File.exists?(file)).to eq(true)
  end

end