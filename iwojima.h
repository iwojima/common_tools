
#ifndef _IWOJIMA_H_
#define _IWOJIMA_H_ 1

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <mqueue.h>
#include <signal.h>
#include <semaphore.h>
#include <pthread.h>
#include <errno.h>
#include <typeinfo>
#include <sys/stat.h>

#include <iostream>
#include <initializer_list>
#include <map>
#include <set>
#include <list>
#include <vector>
#include <algorithm>
#include <functional>
#include <numeric>
#include <iterator>

using namespace std;

#define IN
#define OUT

#define FILE_MODE (S_IRUSR | S_IWUSR)
#define NOERROR 0
#define SEM_NAME "/iwojima.bv"

#define foreach( i , array )  for( i = 0 ; i < strlen(array) ; i++)
#define EXCHANGE(a , b) {int _t = a ; a = b; b = _t;}

#ifdef _FATFS
#define _O_RDWR O_RDWR
#define _O_BINARY O_BINARY
#define _O_CREAT O_CREAT

#define _S_IREAD S_IREAD
#define _S_IWRITE S_IWRITE
#endif
//template <typename _Key, typename _Value>
typedef string String;
typedef bool boolean;
typedef bool Boolean;

//template <typename _Key, typename _Tp, typename _Compare = std::less<_Key>,
//typename _Alloc = std::allocator<std::pair<const _Key, _Tp> > >

//template <typename _key , typename _Value >
/*class MyMap : public std::map<_key , _Tp>
{
    public:
		MyMap();
	private:
	    int num;
	protected:
};*/

template <typename _Key, typename _Value>
class Map {

    public:
		typedef typename map<_Key , _Value>::iterator iter;
		typedef _Key Type_Key;
		typedef _Value Type_Value;

    public:
		Map();
		bool initialize();
		
		bool 
		operator==(Type_Key *);
		
	public:
		bool containsKey(Type_Key key);
		bool containsValue(Type_Value value);
		
		//set<map.Entry<K,V>>entrySet()
		
		int get(Type_Key key , Type_Value value);
		int hashCode();
		
		bool isEmpty();
		//Set<_Key> *keySet()
		bool put(_Key key, _Value value);
		//void putAll(Map<? extends K,? extends V> t);
		_Value remove(Type_Key key);
		int size();
		//Collection<V> 	values() 
	
	public: //Java では hashmap 
		//_Value put(_Key key, _Value value);
	
	private:
		map<_Key , _Value> *m_map;
		typename map<_Key , _Value>::iterator m_iter;
		
		int map_count;
		
	private:
		void clear(void);
		bool native_judge(_Key , _Key);
};

template <typename _Key, typename _Value>
bool Map<_Key , _Value>::initialize()
{
    map_count = 0;
    if (!(m_map = new map<_Key , _Value>())){
	    //atexit(clear);
		return 0;
	}else{
		return 1;
	}
}

template <typename _Key , typename _Value>
Map<_Key , _Value>::Map()
{
	initialize();
}

template <typename _Key , typename _Value>
bool Map<_Key , _Value>::operator==(Type_Key *hitotsu)
{
    if (typeid(Type_Key) == typeid(string)){
		//return strcmp(hitotsu , )
	}
    return false;
}

template <typename _Key , typename _Value>
bool Map<_Key , _Value>::containsKey(_Key key){
	//
	return false;
}

template <typename _Key , typename _Value>
bool Map<_Key , _Value>::containsValue(_Value value){

    m_iter = m_map->begin();
	for( ; m_iter != m_map->end() ; m_iter++ ){
		
		
	}
	return false;
}

template <typename _Key , typename _Value>
int Map<_Key , _Value>::get(Type_Key key , Type_Value value){
	for(m_iter = m_map->begin() ; m_iter!=m_map->end() ; m_iter++){
		if(native_judge(m_iter->first , key)) {
		    //value = m_iter->second;
			//move hanle need by type
			return 0;
		}
	}
	
	return -1;
}

template <typename _Key , typename _Value>
int Map<_Key , _Value>::hashCode(){
	return 0;
}

template <typename _Key , typename _Value>		
bool Map<_Key , _Value>::isEmpty(){
	return false;
}

template <typename _Key , typename _Value>
bool Map<_Key , _Value>::put(_Key key, _Value value)
{
	return (m_map->insert(pair<_Key , _Value>(key , value))).second;
}

template <typename _Key , typename _Value>
bool Map<_Key , _Value>::native_judge(_Key key_hitotsu , _Key key_futatsu){
	if (typeid(_Key)==typeid(int)||typeid(_Key)==typeid(long)||
		typeid(_Key)==typeid(short)||typeid(_Key)==typeid(float)||
		typeid(_Key)==typeid(double)||typeid(_Key)==typeid(char)||
		typeid(_Key)==typeid(string)){
		if (key_hitotsu==key_futatsu) return true;
	}/*else if (typeid(_Key)==typeid(char*)){
		if (strcmp(key_hitotsu , key_futatsu)==0) return true;
	}*/
	
	return false;
}

/*template <typename _Key, typename _Value>
class Map : public map<_Key , _Value>
{
    private:
		//static interface Map.Entry<K,V> 
	public:
		bool containsKey(_Key key);
		bool containsValue(_Value value);
		
		//set<map.Entry<K,V>>entrySet()
		
		_Value get(_Key key);
		int hashCode();
		
		bool isEmpty();
		Set<_Key> *keySet()
		_Value put(_Key key, _Value value) ;
		//void putAll(Map<? extends K,? extends V> t);
		_Value remove(_Key key);
		int size();
		//Collection<V> 	values() 
		
	public:
		Map();
};

template <typename _Key, typename _Value>
Map<_Key , _Value>::Map()
{
	printf("Map<_Key , _Value>::Map()\n");
}

template<typename _key , typename _Value>
bool Map<_Key , _Value>::containsKey(_Key key){
	return 0;
}

template<typename _key , typename _Value>
bool Map<_Key , _Value>::containsValue(_Value value){
	return 0;
}

template<typename _key , typename _Value>
_Value Map<_Key , _Value>::get(_Key key){
	return (_Value)0;
}

template<typename _key , typename _Value>
int Map<_Key , _Value>::hashCode(){
	return 0;
}

template<typename _key , typename _Value>
bool Map<_Key , _Value>::isEmpty(){
	return 0;
}

template<typename _key , typename _Value>
Set<_Key> *Map<_Key , _Value>::keySet(){
	return NULL;
}

template<typename _key , typename _Value>
_Value Map<_Key , _Value>::put(_Key key, _Value value){
	return (_Value)0;
}

template<typename _key , typename _Value>
_Value Map<_Key , _Value>::remove(_Key key){
	return (_Value)0;
}

template<typename _key , typename _Value>
int Map<_Key , _Value>::size(){
	return 0;
}*/


#endif
