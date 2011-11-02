helpers do
  
  def check_main_repo
    if(@github.repo("githunch_bookmarks").response.is_a?(Net::HTTPNotFound))

      puts "Creating repo"
      @github.create_repo("githunch_bookmarks")

      puts "Creating Tree"
      tree_result = @github.create_tree("githunch_bookmarks", "[]", "bookmarks.json")
      puts "Tree sha #{tree_result["sha"]}"

      puts "Creating commit"
      commit_result = @github.create_initial_commit("githunch_bookmarks", tree_result["sha"], "Creating githunch files")
      puts "Commit sha #{commit_result["sha"]}"

      puts "Creating ref"
      ref_result = @github.create_ref("githunch_bookmarks", "refs/heads/master", commit_result["sha"])
      puts "Ref: #{ref_result["sha"].inspect}"

    end
  end
  
end