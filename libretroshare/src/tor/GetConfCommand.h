/* Ricochet - https://ricochet.im/
 * Copyright (C) 2014, John Brooks <john.brooks@dereferenced.net>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *    * Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *    * Redistributions in binary form must reproduce the above
 *      copyright notice, this list of conditions and the following disclaimer
 *      in the documentation and/or other materials provided with the
 *      distribution.
 *
 *    * Neither the names of the copyright owners nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef GETCONFCOMMAND_H
#define GETCONFCOMMAND_H

#include "TorControlCommand.h"
#include <QList>
#include <QVariantMap>

namespace Tor
{

class GetConfCommand : public TorControlCommand
{
    Q_OBJECT
    Q_DISABLE_COPY(GetConfCommand)

    Q_PROPERTY(QVariantMap results READ results CONSTANT)

public:
    enum Type {
        GetConf,
        GetInfo
    };
    const Type type;

    GetConfCommand(Type type);

    ByteArray build(const std::string &key);
    ByteArray build(const std::list<std::string> &keys);

    const std::map<std::string,std::list<std::string> > &results() const { return m_results; }
    std::list<std::string> get(const std::string &key) const;

protected:
    virtual void onReply(int statusCode, const ByteArray &data);
    virtual void onDataLine(const ByteArray &data);
    virtual void onDataFinished();

private:
    std::map<std::string,std::list<std::string> > m_results;
    std::string m_lastKey;
};

}

#endif // GETCONFCOMMAND_H
