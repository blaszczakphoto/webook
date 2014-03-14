# coding: utf-8
$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )

require "page_retriver"
require "content_finder"
require "header_finder"
require "debugger"
require 'fileutils'

     # @urls_d = [
     #  "http://www.zyciejestpiekne.eu/index.php/7-rzeczy-ktore-musisz-zrobic-studiach/",
     #  "http://www.zyciejestpiekne.eu/index.php/wczesne-wstawanie-regulujemy-organizm/",
     #  "http://www.zyciejestpiekne.eu/index.php/gdzie-ruszam-w-2014-roku/",
      # "http://www.zyciejestpiekne.eu/index.php/jak-sie-pakowac-niczego-nie-zapomniec/",
      # "http://www.zyciejestpiekne.eu/index.php/lekcja-biznesu-od-nowojorskiego-taksowkarza/",
      # "http://www.zyciejestpiekne.eu/index.php/autostopowa-chorwacja-zobacz-film/",
      # "http://www.zyciejestpiekne.eu/index.php/5-patentow-na-przyjemne-loty/",
      # "http://www.zyciejestpiekne.eu/index.php/5-denerwujacych-zachowan-pasazerow-samolotow/",
      # "http://www.zyciejestpiekne.eu/index.php/szybki-wypad-do-holandii-zdjecia/",
      # "http://www.zyciejestpiekne.eu/index.php/autentyczne-autostopowe-historie/",
      # "http://www.zyciejestpiekne.eu/index.php/sprzedawanie-sie/",
      # "http://www.zyciejestpiekne.eu/index.php/chillout-w-podrozy-rozwiazanie-konkursu/",
      # "http://www.zyciejestpiekne.eu/index.php/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji/",

      # "http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/wczesne-wstawanie-regulujemy-organizm//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/jak-sie-pakowac-niczego-nie-zapomniec//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/lekcja-biznesu-od-nowojorskiego-taksowkarza//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/autostopowa-chorwacja-zobacz-film//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/5-patentow-na-przyjemne-loty//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/5-denerwujacych-zachowan-pasazerow-samolotow//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/szybki-wypad-do-holandii-zdjecia//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/autentyczne-autostopowe-historie//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/sprzedawanie-sie//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/chillout-w-podrozy-rozwiazanie-konkursu//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/projekt-maraton-czesc-i//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/jak-motywowac-sie-do-biegania//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/projekt-maraton-zakonczony//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/ucisz-wewnetrzny-glos//#disqus_thread/",
      # "http://www.zyciejestpiekne.eu/dzien-ktory-przejdzie-do-historii//#disqus_thread/",

      # "http://www.zyciejestpiekne.eu/index.php/projekt-maraton-czesc-i/",
      # "http://www.zyciejestpiekne.eu/index.php/jak-motywowac-sie-do-biegania/",
      # "http://www.zyciejestpiekne.eu/index.php/projekt-maraton-zakonczony/",
      # "http://www.zyciejestpiekne.eu/index.php/ucisz-wewnetrzny-glos/",
      # "http://www.zyciejestpiekne.eu/index.php/dzien-ktory-przejdzie-do-historii/",



      # "http://www.zyciejestpiekne.eu/misz-masz/",
    # ]

    # @urls_o = [
    #   "http://www.zyciejestpiekne.eu/7-rzeczy-ktore-musisz-zrobic-studiach/",
    #   "http://www.zyciejestpiekne.eu/wczesne-wstawanie-regulujemy-organizm/",
    #   "http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/",
    #   "http://www.zyciejestpiekne.eu/jak-sie-pakowac-niczego-nie-zapomniec/",
    #   "http://www.zyciejestpiekne.eu/lekcja-biznesu-od-nowojorskiego-taksowkarza/",
    #   "http://www.zyciejestpiekne.eu/autostopowa-chorwacja-zobacz-film/",
    #   "http://www.zyciejestpiekne.eu/5-patentow-na-przyjemne-loty/",
    #   "http://www.zyciejestpiekne.eu/5-denerwujacych-zachowan-pasazerow-samolotow/",
    #   "http://www.zyciejestpiekne.eu/szybki-wypad-do-holandii-zdjecia/",
    #   "http://www.zyciejestpiekne.eu/autentyczne-autostopowe-historie/",
    #   "http://www.zyciejestpiekne.eu/sprzedawanie-sie/",
    #   "http://www.zyciejestpiekne.eu/chillout-w-podrozy-rozwiazanie-konkursu/",
    #   "http://www.zyciejestpiekne.eu/fotokonkurs-pokaz-chillout-i-wygraj-wakacje-w-grecji/",

    #   "http://www.zyciejestpiekne.eu/projekt-maraton-czesc-i/",
    #   "http://www.zyciejestpiekne.eu/jak-motywowac-sie-do-biegania/",
    #   "http://www.zyciejestpiekne.eu/projekt-maraton-zakonczony/",
    #   "http://www.zyciejestpiekne.eu/ucisz-wewnetrzny-glos/",
    #   "http://www.zyciejestpiekne.eu/dzien-ktory-przejdzie-do-historii/",
    # ]

    @urls_o = [
      "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html",
      "http://dokturjazon.blox.pl/2011/03/Dwie-strony-rzeki-i-medalu.html",
      "http://dokturjazon.blox.pl/2010/07/Garsc-zasad.html",
]

@urls_d = [
      "http://dokturjazon.blox.pl/2011/03/Dwie-strony-rzeki-i-medalu.rss",
      "http://dokturjazon.blox.pl/html/4259841,1179650,217.html?4735134",
]

dir = File.expand_path("../files/jazon/", __FILE__)
FileUtils.rm_rf(dir) if File.directory?(dir)
FileUtils.mkdir_p(dir)


def create_files(urls, prefix, dir)
	urls.each_with_index do |url, index|
		content = PageRetriver.retrive(url)
		file_name = dir + "/#{prefix}" + index.to_s
		File.open(file_name, 'w') { |file| file.write(content) }
	end
end

def create_object_files(urls, prefix, dir)
	urls.each_with_index do |url, index|
      	html = PageRetriver.retrive(url)
            content, title = " ", " "
            
            if html
                content = ContentFinder.find(html)
                title = HeaderFinder.find(html, content)
            end
          file_name = dir + "/#{prefix}" + index.to_s
          File.open(file_name, 'w') { |file| file.write([html, content, title].join("PHafrAWuwrUf7S*UkEp&")) }
    end
end

create_object_files(@urls_o, "o", dir)
create_object_files(@urls_d, "d", dir)

# TODO: create objects from jazon, ask na stack why not work