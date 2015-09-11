class CreateDomainBindings < ActiveRecord::Migration
  def change
    create_table :domain_bindings do |t|
      t.string :domain
      t.references :domain_bindingtable, polymorphic: true
      t.timestamps null: false
    end
  end
end
