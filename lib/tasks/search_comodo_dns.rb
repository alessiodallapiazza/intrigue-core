module Intrigue
module Task
class SearchComodoDns < BaseTask


  def self.metadata
    {
      :name => "search_comodo_dns",
      :pretty_name => "Search Comodo DNS",
      :authors => ["Anas Ben Salah"],
      :description => "This task looks up whether hosts are blocked byCleanbrowsing.org DNS (8.26.56.26 and 8.20.247.20)",
      :references => ["Cleanbrowsing.org"],
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

    # Query comodo nameservers
    nameservers = ['8.26.56.26', '8.20.247.20']
    _log "Querying #{nameservers}"
    dns_obj = Resolv::DNS.new(nameserver: nameservers)
    res = dns_obj.getaddresses(entity_name)

    # Detected only if there's no resolution
    if res.any?
      _log "Resolves to #{res.map{|x| "#{x.to_name}" }}. Seems we're good!"
    else
      description = "Comodo Secure DNS is a domain name resolution service that resolves "  + 
        "DNS requests through our worldwide network of redundant DNS servers, bringing you " + 
        "the most reliable fully redundant DNS service anywhere, for a safer, smarter and" 
        "faster Internet experience."
      _malicious_entity_detected("ComodoDNS", description) 
    end
    
  end #end run


end
end
end
