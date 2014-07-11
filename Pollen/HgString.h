//
//  HgString.h
//  SlotGame
//
//  Created by keless on 12/16/11.
//  Copyright (c) 2011 Grab. All rights reserved.
//

#ifndef SlotGame_HgString_h
#define SlotGame_HgString_h

#include <string>
#include <stdio.h>
#include <vector>
#include <algorithm>

class HgString : public std::string
{
public:
	//note: std::string's destructor is not virtual
	// this means ~HgString will not be called from a std::string pointer delete
	// DO NOT ADD MEMBER VARIABLES TO HgString OR YOU WILL MEM LEAK (not even an 'int')
	
	//note: std::string's functions are not virtual
	// this means if you add functions to HgString, they are HgString only functions and will not 
	// be used polymorphically by any code expecting std::string 
	//ex: say your functions force uppercase, you send an HgString into some library code, 
	//	  it uses regular std::string functions, your string is no longer uppercase
	
	HgString() : std::string() {}
	HgString(const HgString& other) : std::string(other) {}
	HgString(const char* other) : std::string(other) {}
	HgString(const std::string &other) : std::string(other) {}

	HgString( unsigned int intVal ) {
        char buff[256];
        sprintf(buff, "%u", intVal);
        *this = buff;
    }
	
	static HgString fromDouble ( double realVal ) {
        char buff[256];
        sprintf(buff, "%g", realVal);
        return HgString(buff);
    }
	
	static HgString fromInt ( int intVal ) {
        char buff[256];
        sprintf(buff, "%d", intVal);
        return HgString(buff);
    }
	
	explicit HgString(const char* other, const int size) : std::string( other, size ) {}
	explicit HgString(const int num, const char rep) : std::string( num, rep ) {}
	//explicit HgString(const std::basic_string<char> &other) : std::string(other) {}
	
	bool operator != (const HgString& rhs )
	{
		return !( rhs.compare( *this ) == 0 );
		//return ( rhs.compare(this) == 0 );
	}
	bool operator !=(const char* rhs )
	{
		return !( ( *this ).compare( rhs ) == 0 );
	}
	
	bool operator==(const HgString& rhs )
	{
		return ( rhs.compare( *this ) == 0 );
		//return ( rhs.compare(this) == 0 );
	}
	
	bool operator==(const char* rhs )
	{
		return ( ( *this ).compare( rhs ) == 0 );
	}
	
	/*
	HgString& operator = (const std::string& rhs )
	{
		(*this) += rhs;
		
		return (*this);
	}
	 */
	
	/*
	HgString& operator = (const HgString& rhs )
	{
		(*this) = (*this) + rhs;
		
		return (*this);
	}
	 */
	
	/*
	HgString operator + (const char* rhs )
	{
		HgString result = (*this);
		result += rhs;
		return result; // (*this) + std::string( rhs );
	}
	 */
	
	HgString operator + (const long long rhs )
	{
		char buff[32];
		snprintf(buff, 32, "%lld", rhs);
		return (*this) + buff;
	}
    
	HgString operator + (const unsigned int rhs )
	{
		char buff[32];
		snprintf(buff, 32, "%u", rhs);
		return (*this) + buff;
	}
	
	HgString operator + (const int rhs )
	{
		char buff[32];
		snprintf(buff, 32, "%d", rhs);
		
		return (*this) + buff;
		
		//return ( (*this) + std::string(buff) );
	}
	
	HgString operator + (const float rhs )
	{
		char buff[64];
		snprintf(buff, 64, "%.2f", rhs);
		
		return (*this) + buff;
	}
    
    HgString replace (const HgString& needle, const HgString& repl)
    {
        std::string ret = (*this);
        size_t loc = ret.find(needle);
        while(loc != std::string::npos){
            ret.replace(loc, needle.size(), repl);
            loc = ret.find(needle);
        }
        return ret;
    }
    
    std::vector<HgString> split (char delimiter)
    {
        size_t cursor = 0;
        size_t loc;
        std::vector<HgString> ret;
        
        while(true)
        {
            loc = find(delimiter, cursor);
            if(loc == std::string::npos)
            {
                break; //no more delimiters found.
            }
            ret.push_back(substr(cursor, loc-cursor));
            cursor = loc + 1;
        }
        
        ret.push_back(substr(cursor, size()-cursor));
        
        return ret;
    }
	
	HgString toUpper() const
	{
		HgString copy = *this;
		std::transform(copy.begin(), copy.end(), copy.begin(), ::toupper);
		return copy;
	}
	
	HgString toLower() const
	{
		HgString copy = *this;
		std::transform(copy.begin(), copy.end(), copy.begin(), ::tolower);
		return copy;
	}

    bool beginsWith(const HgString& needle)
    {
        return ((*this).compare(0, needle.length(), needle) == 0);
    }

    bool endsWith(const HgString& needle)
    {
        if((*this).length() < needle.length()) return false;
        return ((*this).compare((*this).length() - needle.length(), needle.length(), needle) == 0);
    }
};


typedef HgString String;

#endif
