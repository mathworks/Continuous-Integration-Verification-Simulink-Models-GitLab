<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
  <html>
      <head>
          <style>
              table, th, td {
                  border: 1.5px solid black;
                  border-collapse: collapse;
                  padding: 5px;
                  width: 60%;
                  margin-left:auto;
                  margin-right:auto;
                  vertical-align: bottom;
                  padding: 15px;
                  }
                  table th {
                  background-color: rgba(192, 188, 188, 0.781);
                  color: black;
                  }
                  table.ModelAdvisor{
                  table-layout: fixed;
                  width: 60%;

                  }
                  table.DesignVerifier{
                  table-layout: fixed;
                  width: 60%;

                  }
                  table.Test{
                  white-space: nowrap;
                  overflow: hidden;
                  text-overflow: ellipsis;
                  table-layout: fixed;
                  width: 60%;

                  }
                  table.Test:hover {
                  overflow: visible;
                  }

                  table.CodeCoverage{
                  table-layout: fixed;
                  width: 60%;

                  }
                  #heading {
                  text-align: center;
                  }
                  h3,span {
                  display: table;
                  margin-left: 20%;
                  margin-right: auto;
                  }
              </style>
          </head>
            <body>
                <h1 id = "heading" style="color:blue"><xsl:value-of select="reports/Title" /></h1>
                <span><b>Runner Description:  </b><xsl:value-of select="reports/Test/RunnerDescription" /></span>
                <br><span><b>Pipeline Created At:  </b><xsl:value-of select="reports/Test/PipelineCreated" /></span></br>
                <br><span><b>Project Repository:  </b><a href="{reports/Test/ProjectURL}"><xsl:value-of select="reports/Test/ProjectURL" /></a></span></br>
                <br><span><b>Commit associated with pipeline:  </b><a href="{reports/Test/Commit}"><xsl:value-of select="reports/Test/CommitID" /></a></span></br>
                <br><h3>Summary</h3></br>
                <table border="1">
                    <tr bgcolor="#9acd32">
                        <th>Description</th>
                        <th>Passed</th>
                        <th>Path</th>
                    </tr>
                    <xsl:for-each select="reports/stage">
                        <tr>
                            <td><xsl:value-of select="Description" /></td>
                            <td><xsl:value-of select="Passed" /></td>
                            <td><a href="{Path}"><xsl:value-of select="Path" /></a></td>
                        </tr>
                    </xsl:for-each>
                </table>
                <h3>Model Advisor</h3>
                <table border="1" class="ModelAdvisor">
                    <tr bgcolor="#9acd32">
                        <th>Warnings</th>
                        <th>Passed</th>
                        <th>Failed</th>
                        <th>Total</th>
                    </tr>
                    <xsl:for-each select="reports/ModelAdvisor">
                        <tr>
                            <td><xsl:value-of select="Warnings" /></td>
                            <td><xsl:value-of select="Passed" /></td>
                            <td><xsl:value-of select="Failed" /></td>
                            <td><xsl:value-of select="Total" /></td>
                        </tr>
                    </xsl:for-each>
                </table>
                <h3>Test</h3>
                <table border="1" class="Test">
                    <tr bgcolor="#9acd32">
                        <th>Passed</th>
                        <th>Failed</th>
                        <th>PDFReport</th>
                        <th>TAPResults</th>
                    </tr>
                    <xsl:for-each select="reports/Test">
                        <tr>
                            <td><xsl:value-of select="Passed" /></td>
                            <td><xsl:value-of select="Failed" /></td>
                            <td><xsl:value-of select="PDFReport" /></td>
                            <td><xsl:value-of select="TAPResults" /></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>