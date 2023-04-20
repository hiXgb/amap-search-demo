import React, { Component } from 'react';
import {
  View,
  TextInput,
  Button,
  FlatList,
  StyleSheet,
  Text,
  Platform,
} from 'react-native';
import { init as poiSearchInit, search } from '../../react-native-amap-search/src';

export default class PoiSearchExample extends Component {
  state = {
    keyword: '学校',
    searchResults: [],
  };

  componentDidMount() {
    poiSearchInit(
      Platform.select({
        android: 'c52c7169e6df23490e3114330098aaac',
        ios: '2d204b71d9d9c2596c3e980b7a290823',
      })
    );
    this.handleSearch();
  }

  handleSearch = async () => {
    const { keyword } = this.state;
    try {
      const result = await search({
        key: keyword,
        longitude: '120.073956',
        latitude: '30.290867',
      });
      if (result) {
        this.setState({ searchResults: result });
      }
    } catch (err) {
      console.warn(`xgb:${err}`);
    }
  };

  renderItem = ({ item }) => (
    <Text style={[styles.logText, { color: 'black' }]}>{item.name}</Text>
  );

  render() {
    const { searchResults, keyword } = this.state;

    return (
      <View style={styles.container}>
        <View style={styles.searchBox}>
          <TextInput
            style={styles.input}
            value={keyword}
            onChangeText={(text) => this.setState({ keyword: text })}
          />
          <Button title="搜索" onPress={this.handleSearch} />
        </View>
        <View style={styles.listContainer}>
          <FlatList
            data={searchResults}
            renderItem={this.renderItem}
            keyExtractor={(item) => item.name}
            keyboardDismissMode="on-drag"
          />
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  searchBox: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 50,
  },
  input: {
    flex: 1,
    backgroundColor: '#fff',
    marginRight: 10,
    height: '100%',
    borderRadius: 5,
    paddingHorizontal: 10,
  },
  listContainer: {
    flex: 1,
  },
  logText: {
    fontSize: 12,
    paddingLeft: 15,
    paddingRight: 15,
    paddingTop: 10,
    paddingBottom: 10,
  },
});