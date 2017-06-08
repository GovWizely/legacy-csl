shared_context 'full results from response' do
  let(:full_results) do
    JSON.parse(response.body)['results'].select do |r|
      r['source'] == source_full_name(source)
    end.map do |r|
      r.delete('score')
      r
    end
  end
end

shared_context 'full results from response sorted by id' do
  include_context 'full results from response'

  let(:sorted_full_results) do
    full_results.sort do |a, b|
      a['id'] <=> b['id']
    end
  end
end

shared_context 'expected results by source' do
  let(:expected_results) do
    expected.map do |i|
      @all_possible_full_results[source][i]
    end
  end
end

shared_context 'expected results by source sorted by id' do
  include_context 'expected results by source'
  let(:sorted_expected_results) do
    expected_results.sort do |a, b|
      a['id'] <=> b['id']
    end
  end
end

shared_examples 'it contains all expected results of source' do
  include_context 'full results from response sorted by id'
  include_context 'expected results by source sorted by id'

  it 'contains them all' do
    aggregate_failures do
      expect(sorted_full_results.count).to eq(sorted_expected_results.count)
      sorted_expected_results.each_with_index do |expected_result, index|
        expect(sorted_full_results[index]).to eq(expected_result)
      end
    end
  end
end

shared_examples 'it contains only results with sources' do
  let(:results) { JSON.parse(response.body)['results'] }
  let(:source_full_names) { sources.map { |s| source_full_name(s) } }
  let(:results_with_source_other_than_expected) do
    results.select { |r| !source_full_names.include?(r['source']) }
  end

  it 'contains only results with sources' do
    expect(results_with_source_other_than_expected.length).to eq 0
  end
end

def source_full_name(source)
  (source.source.is_a?(Hash) && source.source[:full_name]) || source.source[:code]
end
