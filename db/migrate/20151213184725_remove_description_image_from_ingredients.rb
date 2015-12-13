class RemoveDescriptionImageFromIngredients < ActiveRecord::Migration
  def change
    remove_column :ingredients, :description
        remove_column :ingredients, :image_url
      end

end
