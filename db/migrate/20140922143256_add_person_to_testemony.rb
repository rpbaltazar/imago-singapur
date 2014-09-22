class AddPersonToTestemony < ActiveRecord::Migration
  def change
    add_reference :testemonies, :person, index: true
  end
end
