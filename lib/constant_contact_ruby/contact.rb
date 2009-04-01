module ConstantContact
  class Contact
    CONTACT_ATTRIBUTES = ['Status', 'EmailAddress', 'EmailType', 'Name', 'FirstName', 'LastName', 'JobTitle',
      'CompanyName', 'HomePhone', 'WorkPhone', 'Addr1', 'Addr2', 'Addr3', 'City', 'StateCode', 'StateName',
      'CountryCode', 'CountryName', 'PostalCode', 'SubPostalCode', 'Note', 'CustomField1', 'CustomField2',
      'CustomField3', 'CustomField4', 'CustomField5', 'CustomField6', 'CustomField7', 'CustomField8','CustomField9',
      'CustomField10', 'CustomField11', 'CustomField12', 'CustomField13', 'CustomField14', 'CustomField15',
      'InsertTime', 'LastUpdateTime']

    attr_accessor :id, :attributes

    def self.from_xml(xml, session)
      contact = Contact.new(session)

      xml.children.each do |child_node|
        contact.attributes[child_node.name] = child_node.content if CONTACT_ATTRIBUTES.include?(child_node.name)
      end

      return contact
    end
    
    def initialize(session)
      @session = session
      @attributes = {} 
    end

    private

    def method_missing(method, *args, &block)
      attribute = method.to_s.split("_").collect{|a| a.capitalize}.join("")
      if CONTACT_ATTRIBUTES.include?(attribute) then
        @attributes[attribute]
      else
        super
      end
    end

  end
end
