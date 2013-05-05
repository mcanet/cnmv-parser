require 'rubygems'
require 'mechanize'
require 'csv'

agent = Mechanize.new

def company_page_url(id)
    "http://cnmv.es/Portal/Consultas/DerechosVoto/PS_AC_INI.aspx?nif=#{id}"
end

CSV::readlines('companies.csv').each do |id, company_name|
    next if id.start_with? '#'

    # Amazingly, the CNMV site uses the Referer header to decide which company we're interested in,
    # so we have to fetch this page first, even if we don't care about its contents!
    # PS: Actually, we could add a fake Referer via Mechanize, but it may be that the site
    # is setting something in the session. Can't be bothered to check, this works.
    page = agent.get(company_page_url(id))
    # Sometimes they don't use the hyphen in the id, so we try both
    if page.content.include?('No hay datos para mostrar')
        page = agent.get(company_page_url(id.delete('-')))
    end
    
    # Download the relevant sections
    puts "Retrieving board members for #{company_name} (#{id})..."
    board_link = page.link_with(:text => /Consejo/)
    if board_link
        File.open("staging/#{id}_board.html", 'w') {|f| f.write(board_link.click.content) }
    else
        puts "Warning: skipped! not found."
    end
    
    puts "Retrieving big shareholders for #{company_name} (#{id})..."
    shareholders_link = page.link_with(:text => /derechos de voto/)
    if shareholders_link
        File.open("staging/#{id}_shareholders.html", 'w') {|f| f.write(shareholders_link.click.content) }
    else
        puts "Warning: skipped! not found."
    end
end
