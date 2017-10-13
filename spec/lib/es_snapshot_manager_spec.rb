require 'spec_helper'

describe ESSnapshotManager do
  let(:index_pattern) { 'snapshot:webservices:screening_list:*,snapshot:webservices:url_mappers*'.freeze }

  describe '.restore' do
    let(:now_string) { '2017-09-22 14:48:11 -0400' }
    let(:repository_name) { 'repo_20170922_144811' }

    before do
      allow(Rails).to receive(:env).and_return('snapshot')
      expect(Time).to receive(:now).and_return(Time.parse(now_string))
      expect(described_class).to receive(:close_indices_with_open_status).with(index_pattern)
    end

    it 'restores snapshot' do
      expected_create_repository_params = {
        repository: repository_name,
        body:       {
          type:     's3',
          settings: {
            access_key: 'my_aws_access_key',
            bucket:     'my_aws_bucket',
            readonly:   true,
            region:     'my_aws_region',
            secret_key: 'my_aws_secret_key'
          }
        }
      }
      expect(ES.client.snapshot).to receive(:create_repository).with(expected_create_repository_params)

      expected_restore_params = {
        repository:          repository_name,
        snapshot:            'my_aws_snapshot_name',
        wait_for_completion: true,
        body:                {
          indices: index_pattern,
        }
      }
      expect(ES.client.snapshot).to receive(:restore).with(expected_restore_params).ordered

      expected_delete_repository_params = {
        repository: repository_name
      }
      expect(ES.client.snapshot).to receive(:delete_repository).with(expected_delete_repository_params)

      aws_params = {
        access_key: 'my_aws_access_key',
        secret_key: 'my_aws_secret_key',
        region:     'my_aws_region',
        bucket:     'my_aws_bucket'
      }
      described_class.restore aws_params, 'my_aws_snapshot_name'

    end
  end

  describe '.close_indices_with_open_status' do
    context 'when indices in open status are present' do
      before do
        indices = [
          {
            'index'  => 'snapshot:webservices:screening_list:mock',
            'status' => 'open'
          }
        ]

        expect(ES.client.cat).to receive(:indices).
          with(index: index_pattern, format: 'json').
          and_return(indices)
      end

      it 'close indices' do
        expect(ES.client.indices).to receive(:close).with(index: index_pattern)
        described_class.close_indices_with_open_status index_pattern
      end
    end

    context 'when indices in open status are not present' do
      before do
        indices = [
          {
            'index'  => 'snapshot:webservices:mock',
            'status' => 'close'
          }
        ]

        expect(ES.client.cat).to receive(:indices).
          with(index: index_pattern, format: 'json').
          and_return(indices)
      end

      it 'does not close indices' do
        expect(ES.client.indices).not_to receive(:close).with(index: index_pattern)
        described_class.close_indices_with_open_status index_pattern
      end
    end
  end
end
