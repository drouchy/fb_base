def search_entry_for_name_in_ranking(ranking, name)
  ranking.find{|entry| entry[:name] == name}
end