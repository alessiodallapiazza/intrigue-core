module Intrigue
module Entity
class Organization < Intrigue::Model::Entity

  def self.metadata
    {
      :name => "Organization",
      :description => "TODO"
    }
  end


  def validate_entity
    name =~ /^\w.*$/
  end

end
end
end
