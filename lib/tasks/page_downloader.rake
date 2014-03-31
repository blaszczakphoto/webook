# coding: utf-8
$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )

require "page_retriver"
require "content_finder"
require "header_finder"
require "debugger"
require 'fileutils'



@urls_o = [
  "http://www.opoka.org.pl/biblioteka/T/TB/lukasz_zamyslenia04.html",
  "http://dokturjazon.blox.pl/2011/03/Problemy-z-czasoprzestrzenia.html"
]




dir = File.expand_path("spec/files/opoka_znaki", Rails.root)
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

desc "I am short, but comprehensive description for my cool task"

task download_page: [:environment] do
  create_files(@urls_o, "o", dir)
  # create_object_files(@urls_d, "d", dir)
end

