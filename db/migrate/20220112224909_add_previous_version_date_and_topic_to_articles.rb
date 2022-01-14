class AddPreviousVersionDateAndTopicToArticles < ActiveRecord::Migration[5.0]
  def change
    add_column :articles, :previous_version_date, :datetime
    add_column :articles, :topic, :string
  end  
end
