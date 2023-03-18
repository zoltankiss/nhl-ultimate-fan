class FunFactPrompt < ActiveRecord::Migration[7.0]
  def change
    add_column :fun_facts, :prompt, :string
  end
end
