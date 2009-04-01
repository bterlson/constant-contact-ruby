module ConstantContact
  class Contacts
    def initialize(session)
      @session = session
    end

    def all
      @session.get("contacts")
    end

    def find
    end
  end
end
