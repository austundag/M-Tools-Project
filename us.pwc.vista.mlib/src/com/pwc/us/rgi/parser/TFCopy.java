//---------------------------------------------------------------------------
// Copyright 2013 PwC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------

package com.pwc.us.rgi.parser;

import com.pwc.us.rgi.parsergen.ObjectSupply;

public class TFCopy<T extends Token> extends TFWithAdaptor<T> {
	private TokenFactory<T> tf;
	
	public TFCopy(String name) {
		super(name);
	}
	
	public void setMaster(TokenFactory<T> master) {
		this.tf = master;
	}
	
	@Override
	protected T tokenizeOnly(Text text, ObjectSupply<T> objectSupply) throws SyntaxErrorException {
		return this.tf.tokenize(text, objectSupply);
	}
}
