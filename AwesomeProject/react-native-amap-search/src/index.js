import { NativeModules } from 'react-native';

const { AMapPoiSearch } = NativeModules;

export const init = (params) => AMapPoiSearch.init(params);
export const search = (params) => AMapPoiSearch.search(params);

export default AMapPoiSearch;