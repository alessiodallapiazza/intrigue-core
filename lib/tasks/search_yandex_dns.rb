require 'resolv'

module Intrigue
module Task
class SearchYandexDns < BaseTask


  def self.metadata
    {
      :name => "search_yandex_dns",
      :pretty_name => "Search Yandex DNS",
      :authors => ["Anas Ben Salah"],
      :description => "This task looks up whether hosts are blocked by Yandex DNS",
      :references => ["https://dns.yandex.com/"],
      :type => "discovery",
      :passive => true,
      :allowed_types => ["Domain", "DnsRecord"],
      :example_entities => [{"type" => "Domain", "details" => {"name" => "intrigue.io"}}],
      :allowed_options => [],
      :created_types => []
    }
  end


  ## Default method, subclasses must override this
  def run
    super

    entity_name = _get_entity_name

    # Query yandex nameservers
    nameservers = ['77.88.8.88','77.88.8.2']
    _log "Querying #{nameservers}"
    dns_obj = Resolv::DNS.new(nameserver: nameservers)
    res = dns_obj.getaddresses(entity_name)

    # Detected only if there's no resolution
    if res.any?
      _log "Resolves to #{res.map{|x| "#{x.to_name}" }}. Seems we're good!"
    else
      
      description = "When attempting to open a site, Yandex.DNS (Safe) will block the download " +
      "of any information from it and warn the user. Yandex uses its own anti-virus software that " +  
      "checks sites for malware. Yandex.DNS uses its own anti-virus software operating on Yandex " +
      "algorithms, as well as signature technology by Sophos."

      _malicious_entity_detected("YandexDNS", description) 
    end

  end #end run


end
end
end
