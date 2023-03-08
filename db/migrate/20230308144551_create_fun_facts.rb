class CreateFunFacts < ActiveRecord::Migration[7.0]
  def change
    create_table :fun_facts do |t|
      t.text   :fun_fact
      t.bigint :fun_factable_id
      t.string :fun_factable_type

      t.timestamps
    end
  end
end
