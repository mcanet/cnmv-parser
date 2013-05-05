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
    shareholders_table = doc.css('#ctl00_ContentPrincipal_gridNoConsejerosA')
    shareholders = shareholders_table.css('tr')[3..-1] || []    # skip first 3 rows: headers

    shareholders.each do |member|
        columns = member.css('td').map{|s| s.text.strip}
        puts CSV::generate_line([
            company_name,
            columns[0], 
            number_to_english(columns[3]),
            columns[4] ])
    end
end

puts 'Empresa,Nombre,% Derechos Voto,Fecha Registro CNMV'
Dir['staging/*_shareholders.html'].each {|filename| parse_file(filename)}
