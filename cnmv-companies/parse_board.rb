require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'csv'
require 'iconv'

def number_to_english(s)
    s.gsub('.','').gsub(',', '.')
end

def parse_file(filename)
    # Some weird encoding issue going on CNMV site, not fully sure about this
    content = Iconv.conv('iso-8859-1', 'utf-8', open(filename).read)  # Convert to UTF-8
    
    doc = Nokogiri::HTML(content)
    company_name = doc.css('#ctl00_lblSubtitulo').text
    board = doc.css('#ctl00_ContentPrincipal_gridConsejo')
    members = board.css('tr')[1..-2]    # skip first and last: header/footer

    members.each do |member|
        columns = member.css('td').map{|s| s.text.strip}
        puts CSV::generate_line([
            company_name,
            columns[0],
            columns[3],
            number_to_english(columns[1]),
            columns[2] ])
    end
end

puts 'Empresa,Nombre,Cargo,% Derechos Voto,Fecha Nombramiento'

Dir['staging/*_board.html'].each {|filename| parse_file(filename)}
