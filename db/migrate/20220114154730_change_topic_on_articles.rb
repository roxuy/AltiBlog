class ChangeTopicOnArticles < ActiveRecord::Migration[5.0]
  def change
    remove_column :articles, :topic, :string
    add_column :articles, :topic, :string, default: 'others'
  end
end
