package mqmetric

/*
  Copyright (c) IBM Corporation 2016, 2019

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

   Contributors:
     Mark Taylor - Initial Contribution
*/

type Logger struct {
	Debug func(string, ...interface{})
	Info  func(string, ...interface{})
	Error func(string, ...interface{})
}

var logger *Logger = nil

func SetLogger(l *Logger) {
	logger = l
}

func logDebug(format string, v ...interface{}) {
	if logger != nil && logger.Debug != nil {
		logger.Debug(format, v...)
	}
}
func logInfo(format string, v ...interface{}) {
	if logger != nil && logger.Info != nil {
		logger.Info(format, v...)
	}
}
func logError(format string, v ...interface{}) {
	if logger != nil && logger.Info != nil {
		logger.Error(format, v...)
	}
}
